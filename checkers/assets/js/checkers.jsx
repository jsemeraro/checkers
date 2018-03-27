import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';
import socket from "./socket";

export default class Checkers extends React.Component {
  constructor(props) {
    super(props);
    this.state = {game: null, selected: [-1, -1]};
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

  checkerSelected(location) {
    this.setState({selected: location})
    let board = this.state.game.board;
    let [x, y] = location;
    let currLocation = board[x][y];



    // this.channel.push("move_checker").receive("ok", this.gotView.bind(this))
  }

  render() {
    if (this.state.game) {
      let board = this.state.game.board;
      let base_board = {};
      let rowsArr = [];

      for(let x in board) {
        let cols = [];
        for(let y in board[x]) {
          let bool = (x == this.state.selected[0]) && (y == this.state.selected[1]);
          cols.push(<Square place={board[x][y]} selected={bool} location={[x,y]} whenClicked={this.checkerSelected.bind(this)} />);
        }
        rowsArr.push(<tr>{cols}</tr>);
      }

      console.log(rowsArr);

      return (
        <div className="board-layout">
          <table>
            <tbody>
              {rowsArr}
            </tbody>
          </table>
        </div>
      );
    } else {
      return (<span>Loading</span>);
    }
  }
}

function Square(props) {
  let tile = props.place.tile;
  let location = props.location;
  let selected = props.selected;
  let selectedChecker = props.whenClicked;

  if (tile == "illegal") {
    return <td><div class="square brown"></div></td>;
  } else {
    return <td><div class="square tan">{renderChecker(props.place, location, selectedChecker, selected)}</div></td>;
  }
}

function renderChecker(place, location, selectedFunction, selected) {
  if (place.color === "red") {
    if (selected) {
      return <div className="checker red selected" onClick={() => selectedFunction(location)} ></div>;
    } else {
      return <div className="checker red" onClick={() => selectedFunction(location)} ></div>;
    }
  } else if (place.color === "black") {
    if (selected) {
      return <div className="checker black selected" onClick={() => selectedFunction(location)} ></div>;
    } else {
      return <div className="checker black" onClick={() => selectedFunction(location)} ></div>;
    }
  } else {
    return (null);
  }
}
