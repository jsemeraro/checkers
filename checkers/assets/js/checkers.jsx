import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';
import socket from "./socket";

export default class Checkers extends React.Component {
  constructor(props) {
    super(props);
    this.state = {game: null, selected: [-1, -1], playerColor: null, possibleLocations: []};
    this.channel = this.props.channel;
    this.channel.on("view", this.gotView.bind(this));
    this.name = this.props.name;
    this.channel.push("request_view").receive("ok", this.gotView.bind(this))
  }

  // game = {board: {}, player: color}
  gotView({game, player}) {
    console.log(game)
    this.setState({game: game});
    if(player){
      console.log(player);
      this.setState({playerColor: player});
    }
    console.log("New view", game.board);
  }

  checkerSelected(location) {
    let board = this.state.game.board;
    let x = parseInt(location[0]);
    let y = parseInt(location[1]);
    let currLocation = board[x][y];
    let possLocations = [];

    if (currLocation.color != this.state.playerColor) {
      return (null);
    } else {
      let newLeftY = y-1;
      let newRightY = y+1;
      

      // black moves up: X decrements
      if (this.state.playerColor == "black" && currLocation.color == "black") {
        this.setState({selected: location});
        let newX = x-1;
        console.log(board[newX][newLeftY]);
        if (newX != -1) {
          if (newLeftY != -1 && (board[newX][newLeftY].color != "black")) {
            let leftColor = board[newX][newLeftY].color;
            if (leftColor == "none") {
              possLocations.push([newX, newLeftY]);
            } else if ((leftColor == "red") && (newLeftY-1 != -1) && (newX-1 != -1) && (board[newX-1][newLeftY-1].color == "none")) {
              possLocations.push([newX-1, newLeftY-1]);
            }
          } 
          if ((newRightY != 8) && (board[newX][newRightY].color != "black")) {
            let rightColor = board[newX][newRightY].color;
            if (rightColor == "none") {
              possLocations.push([newX, newRightY]);
            } else if ((rightColor == "red") && (newRightY+1 != 8) && (newX-1 != -1) && (board[newX-1][newRightY+1].color == "none")) {
              possLocations.push([newX-1, newRightY+1]);
            }
          }
          this.setState({possibleLocations: possLocations});
        }
      // red moves down: X increments
      } else if (this.state.playerColor == "red" && currLocation.color == "red") {
        this.setState({selected: location});
        let newX = x+1;
        console.log(board[newX][newLeftY]);
        console.log(board[newX][newRightY]);
        if (newX != 8) {
          if ((newLeftY != -1) && (board[newX][newLeftY].color != "red")) {
            let leftColor = board[newX][newLeftY].color;
            if (leftColor == "none") {
              possLocations.push([newX, newLeftY]);
            } else if ((leftColor == "black") && (newLeftY-1 != -1) && (newX+1 != 8) && (board[newX+1][newLeftY-1].color == "none")) {
              possLocations.push([newX-1, newLeftY-1]);
            }
          }
          if ((newRightY != 8) && (board[newX][newRightY].color != "red")) {
            let rightColor = board[newX][newRightY].color;
            if (rightColor == "none") {
              possLocations.push([newX, newRightY]);
            } else if ((rightColor == "black") && (newRightY+1 != 8) && (newX+1 != 8) && (board[newX+1][newRightY+1].color == "none")) {
              possLocations.push([newX+1, newRightY+1]);
            }
          }
          this.setState({possibleLocations: possLocations});
        }
      }
    }
  }

  tileSelected(moveToTile) {
    let [selX, selY] = this.state.selected;
    let [tileX, tileY] = moveToTile;
    [selX, selY] = [parseInt(selX), parseInt(selY)];
    [tileX, tileY] = [parseInt(tileX), parseInt(tileY)];
    this.channel.push("move_checker", {origin: [selX, selY], dest: [tileX, tileY]}).receive("ok", (game) => {
      this.setState({possibleLocations: []});
    });
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
          let possible = this.state.possibleLocations.some(([lx,ly]) => lx == x && ly == y);
          cols.push(<Square place={board[x][y]} selected={bool} possible={possible} location={[x,y]} tileClicked={this.tileSelected.bind(this)} checkerClicked={this.checkerSelected.bind(this)} />);
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
  let [x, y] = props.location;
  let selected = props.selected;
  let selectedChecker = props.checkerClicked;
  let possible = props.possible;
  let selectedTile = props.tileClicked;

  if (tile == "illegal") {
    return <td><div className="square brown"></div></td>;
  } else if (possible) {
    return <td><div className="square possible" onClick={() => selectedTile(props.location)} ></div></td>;
  } else {
    return <td><div className="square tan">{renderChecker(props.place, props.location, selectedChecker, selected)}</div></td>;
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
