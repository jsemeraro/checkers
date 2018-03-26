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
    this.name = props.name;
    this.channel = socket.channel("games:" + this.name, {});

    this.channel.join()
        .receive("ok", this.gotView.bind(this))
        .receive("error", resp => { console.log("Unable to join", resp) });
  }

  // game = {board: {}, player: color}
  gotView(game) {
    this.setState(game);
    console.log("New view", this.state.game.board);
  }

  render() {
    

    //   let score_one = this.state.score_one;
    //   let score_two = this.state.score_two;
    //   let board = this.state.board;
    //   let board_list = [];

    //   for(var i in board) {
    //     for(var j in board) {
    //       //console.log(board[i][j]);
    //       board_list.push(<Square square={board[i][j]} x={i} y={j}></Square>); //TODO make this a square instead (which will make it more table like hopefully)
    //     }
    //   }

    //   let first_row = board_list.slice(0, 8);
    //   let second_row = board_list.slice(8, 16);
    //   let third_row = board_list.slice(16, 24);
    //   let fourth_row = board_list.slice(24, 32);
    //   let fifth_row = board_list.slice(32, 40);
    //   let sixth_row = board_list.slice(40, 48);
    //   let seventh_row = board_list.slice(48, 56);
    //   let eighth_row = board_list.slice(56, 64);

    // return (
    //   <body>
    //     <div className="row">
    //       <p>Player 1 Score: {score_one}</p>
    //       <p>Player 2 Score: {score_two}</p>
    //     </div>
    //     <div>
    //       <table>
    //         <tbody>
    //           <tr>{ first_row }</tr>
    //           <tr>{ second_row }</tr>
    //           <tr>{ third_row }</tr>
    //           <tr>{ fourth_row }</tr>
    //           <tr>{ fifth_row }</tr>
    //           <tr>{ sixth_row }</tr>
    //           <tr>{ seventh_row }</tr>
    //           <tr>{ eighth_row }</tr>
    //         </tbody>
    //       </table>
    //     </div>
    //   </body>
    // );
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
