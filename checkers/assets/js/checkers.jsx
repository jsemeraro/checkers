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
    this.state = {
      board: {},
      score: 0,
    };

    this.channel.join()
        .receive("ok", this.gotView.bind(this))
        .receive("error", resp => { console.log("Unable to join", resp) });
  }

  gotView(view) {
    console.log("New view", view);
    this.setState(view.game);
  }

  render() {
      let score = this.state.score;
      let board = this.state.board;
      let board_list = [];

      for(var i in board) {
        for(var j in board) {
          board_list.push(<h1>i</h1>);
        }
      }

    return (
      <body>
        <div className="row">
          <h3>Score: {score}</h3>
        </div>
        <div>
          { board_list }
        </div>
      </body>
    );
  }
}

function Square() {
  let square = props.square;


}
