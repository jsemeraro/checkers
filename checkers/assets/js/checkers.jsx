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
          board_list.push(<td>i</td>); //TODO make this a square instead (which will make it more table like hopefully)
        }
      }

      let first_row = board_list.slice(0, 8);
      let second_row = board_list.slice(8, 16);
      let third_row = board_list.slice(16, 24);
      let fourth_row = board_list.slice(24, 32);
      let fifth_row = board_list.slice(32, 40);
      let sixth_row = board_list.slice(40, 48);
      let seventh_row = board_list.slice(48, 56);
      let eighth_row = board_list.slice(56, 64);

    return (
      <body>
        <div className="row">
          <h3>Score: {score}</h3>
        </div>
        <div>
          <table>
            <tbody>
              <tr>{ first_row }</tr>
              <tr>{ second_row }</tr>
              <tr>{ third_row }</tr>
              <tr>{ fourth_row }</tr>
              <tr>{ fifth_row }</tr>
              <tr>{ sixth_row }</tr>
              <tr>{ seventh_row }</tr>
              <tr>{ eighth_row }</tr>
            </tbody>
          </table>
        </div>
      </body>
    );
  }
}

function Square() {
  let square = props.square;


}
