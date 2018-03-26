import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';
import socket from "./socket";

// export default function game_init(root, channel) {
//   ReactDOM.render(<Checkers channel={channel} />, root);
// }

export default class Checkers extends React.Component {
  constructor(props) {
    super(props);
    this.state = {game: null};
    this.channel = this.props.channel;
    this.name = this.props.name;
    this.channel.push("request_view").receive("ok", this.gotView.bind(this))
  }

  // game = {board: {}, player: color}
  gotView({game, playerColor}) {
    console.log(game)
    this.setState({game: game});
    console.log("New view", game.board);
  }

  render() {
    

      // let score_one = this.state.score_one;
      // let score_two = this.state.score_two;
    if (this.state.game) {
      console.log("In Render")
      let board = this.state.game.board;
      let board_list = [];

      for(var i in board) {
        for(var j in board) {
          //console.log(board[i][j]);
          board_list.push(<Square square={board[i][j]} x={i} y={j}></Square>); //TODO make this a square instead (which will make it more table like hopefully)
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
    } else {
      return (<span>Loading</span>);
    }
  }
}

function Square(props) {
  let square = props.square;
  let x = props.x;
  let y = props.y;

    if (square.checker) {
      return <td><div id="checker-square">{x}{y}</div></td>; //TODO use buttons as checkers?
    }
    if (((x%2 == 0) && (y%2 == 0)) || (!(x%2 == 0) && !(y%2 == 0))) {
      return <td><div id="tan-square">{x}{y}</div></td>;
    }
    else {
      return <td><div id="brown-square">{x}{y}</div></td>;
    }
}
