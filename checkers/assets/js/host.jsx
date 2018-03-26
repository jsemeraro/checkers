import React from 'react';
import ReactDOM from 'react-dom';
import { Button, Input } from 'reactstrap';
import Socket from './socket';
import Login from './login';
import Checkers from './checkers';

export default function init_host(root) {
    ReactDOM.render(<Host />, root);
}

class Host extends React.Component {
    constructor(props) {
        super(props);
        this.state = { inGame: false };
    }

    gameCreated(gameName) {
        this.setState({ inGame: gameName });
    }

    render() {
        console.log(this.state.inGame);
        if (this.state.inGame) {
            return (<Checkers name={this.state.inGame} />);
        } else {
            return (<Login createdGame={this.gameCreated.bind(this)} />);
        }
    }
}