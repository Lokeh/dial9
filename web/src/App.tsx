import * as React from 'react';
import 'whatwg-fetch';
import 'bootstrap/dist/css/bootstrap.css';
// import 'bootstrap/dist/css/bootstrap-theme.css';
import { Subscription, Observable } from 'rxjs';
import {
  Grid,
  Row,
  Col,
  PageHeader,
  ListGroup,
  ListGroupItem,
  ProgressBar,
} from 'react-bootstrap';
import { Toast } from './components/Toast';
import { fromEventSource } from './lib/eventSource';

interface User {
  name: string;
  number: string;
};

interface AppState {
  selected: User;
  locked: boolean;
  timeout: number;
  time_left: number;
  users: {
    [key: string]: string;
  };
  showConnected: boolean;
};

const host = process.env.NODE_ENV === 'development' ?
  'http://localhost:4000' :
  '/dial9';

class App extends React.Component<null, AppState> {
  stateStream: Subscription;
  connectedStream: Subscription;

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
      showConnected: false,
    };
  }

  componentWillMount() {
    const eventSource = fromEventSource(`${host}/state`);
    this.stateStream = eventSource
      .filter(({ type }: Event) => type === 'message')
      .subscribe(
        (res: sse.IOnMessageEvent) => {
          const state = JSON.parse(res.data);
          this.setState(state);
        },
        (err) => {
          console.log(err);
        }
      );

    this.connectedStream = eventSource
      .filter(({ type }: Event) => type === "open")
      .do(() => this.setState({ showConnected: true }))
      .concatMap(() => Observable.timer(5000))
      .do(() => this.setState({ showConnected: false }))
      .subscribe();

  }

  componentWillUnmount() {
    this.stateStream.unsubscribe();
  }

  selectUser(name: string) {
    fetch(`${host}/select/${name}`);
  }

  render() {
    console.log(this.state);
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
        <Toast visible={this.state.showConnected}>
          <div style={{ textAlign: 'center' }}>
            Connected
          </div>
        </Toast>
      </div>
    );
  }
}

export default App;
