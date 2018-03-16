import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function game_init(root, channel) {
  ReactDOM.render(<Checkers channel={channel} />, root);
}

class Checkers extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {};

    this.channel.join()
        .receive("ok", this.gotView.bind(this))
        .receive("error", resp => { console.log("Unable to join", resp) });
  }

  gotView(view) {
    console.log("New view", view);
    this.setState(view.game);
  }

  render() {
    return (<div></div>);
  }
}
