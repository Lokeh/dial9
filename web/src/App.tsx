import * as React from 'react';
import './App.css';
import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap/dist/css/bootstrap-theme.css';
import {
  Grid,
  Row,
  Col,
  PageHeader,
} from 'react-bootstrap';

class App extends React.Component<null, null> {
  render() {
    return (
      <div>
        <Grid>
          <Row><Col><PageHeader style={{textAlign: "center"}}>Dial9</PageHeader></Col></Row>
          <Row>
            <Col>
              
            </Col>
          </Row>
        </Grid>
      </div>
    );
  }
}

export default App;
