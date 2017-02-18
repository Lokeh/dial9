import * as React from 'react';
import 'whatwg-fetch';
import 'bootstrap/dist/css/bootstrap.css';
// import 'bootstrap/dist/css/bootstrap-theme.css';
import { Subscription } from 'rxjs';
import {
  Grid,
  Row,
  Col,
  PageHeader,
  ListGroup,
  ListGroupItem,
  ProgressBar,
} from 'react-bootstrap';
import { fromEventSource } from './lib/eventSource';

interface User {
  name: string;
  number: string;
};

interface AppSource {
  selected: User;
  locked: boolean;
  timeout: number;
  time_left: number;
  users: {
    [key: string]: string;
  };
};

const host = process.env.NODE_ENV === 'development' ?
  'http://localhost:4000' :
  '';

class App extends React.Component<null, AppSource> {
  eventSource: Subscription;
  constructor() {
    super();
    this.state = {
      selected: {
        name: 'default',
        number: 'whatever',
      },
      locked: false,
      timeout: 0,
      time_left: 0,
      users: {
        'default': 'whatever',
      },
    };
  }

  componentWillMount() {
    this.eventSource = fromEventSource<AppSource>(`${host}/state`).subscribe(
      (res) => {
        this.setState(res);
        console.log(res);
      },
      (err) => {
        console.log(err);
      }
    );
  }

  componentWillUnmount() {
    this.eventSource.unsubscribe();
  }

  selectUser(name: string) {
    fetch(`${host}/select/${name}`);
  }

  render() {
    return (
      <div>
        <Grid style={{maxWidth: 600}}>
          <Row><Col><PageHeader style={{textAlign: 'center'}}>Dial9</PageHeader></Col></Row>
          <Row>
            <Col>
              {this.state.time_left !== 0 ?
                <ProgressBar max={this.state.timeout} now={this.state.time_left - 1} /> :
                null
              }
              <ListGroup>
                {Object.keys(this.state.users)
                  .filter(name => name !== 'default')
                  .map(name =>
                    <ListGroupItem
                      active={name === this.state.selected.name}
                      disabled={name !== this.state.selected.name && this.state.selected.name !== 'default'}
                      onClick={() => this.selectUser(name)}
                      key={name}
                    >
                      {name}
                    </ListGroupItem>
                  )}
              </ListGroup>
            </Col>
          </Row>
        </Grid>
      </div>
    );
  }
}

export default App;
