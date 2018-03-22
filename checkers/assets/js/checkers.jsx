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
      let board = _.map(this.state.board, (square, ii) => {
        return <Square square={square}/>;
      });

      let firstFour = board.slice(0, 4).map(square => {
        return <div className="col">{square}</div>
      });


    return (
      <body>
        <div className="row">
          <h3>Score: {score}</h3>
        </div>
        <div className="row">
          {firstFour}
        </div>
      </body>
    );
  }
}

function Square(props) {
  let square = props.square;

  return <div className="square"></div>
}
