import React from 'react';
import ReactDOM from 'react-dom';
import { Button, Input } from 'reactstrap';
import Socket from './socket';

export default class Login extends React.Component {
    constructor(props) {
        super(props);
        this.state = { name: "" };
    }

    update_text(e) {
        this.setState({ name: e.target.value });
    }

    create_game() {
        let channel = Socket.channel(`games:${this.state.name}`, {});
        channel.join()
        .receive("ok", resp => { 
            console.log("Joined successfully", resp); 
            this.props.createdGame(this.state.name, channel);
        })
        .receive("error", resp => { console.log("Unable to join", resp); });
    }

    render() {
        return (
            <div>
                <h1>Join a Game:</h1>
                <input onChange={this.update_text.bind(this)} value={this.state.name} type="text"></input>
                <Button onClick={this.create_game.bind(this)}>Join</Button>
            </div>
        );
    }

}