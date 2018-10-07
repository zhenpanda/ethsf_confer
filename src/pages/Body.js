import React, {Component} from 'react';
import Wallet from './Wallet';
import WalletToo from './WalletToo';

class Body extends Component {

    displayOnExplorer(stage) {
        if(this.props.stage) {
            return(
                <div>
                    <div className="send-proof moveFromTopFade delay200">
                        <div className="person">Sender: Alice</div>
                        <div className="amount">Sending Amount: 10</div>
                        <div className="amount">Reciver: Bob</div>
                    </div>
                </div>
            )
        }

    }
    displayUserLeft(userState) {
        // console.log(userState);
        if(userState === undefined || userState === "Alice") {
            return(
                <Wallet 
                    display="visiable" 
                    balance="100"
                    proof={this.props.proof}
                    makeProof={this.props.makeProof}
                    moveStage={this.props.moveStage}
                />
            )
        }else if(userState === "Bob") {
            return(
                <Wallet 
                    display="none"
                    balance="100"
                />
            )
        }
    }
    displayUserRight(userState) {
        if(userState === undefined || userState === "Alice") {
            return(
                <Wallet 
                    display="none"
                    balance="100"
                />
            )
        }else if(userState === "Bob") {
            return(
                <WalletToo 
                    display="visiable" 
                    balance="5"
                />
            )
        }
    }

    render() {
        return(
            <div className="body">
                <div className="row">

                    <div className="col s4 m4">
                        {this.displayUserLeft(this.props.user)}
                    </div>
                    
                    <div className="col s4 m4">
                        <div className="explorer">
                            {this.displayOnExplorer(this.props.stage)}
                        </div>
                    </div>
                    
                    <div className="col s4 m4">
                            {this.displayUserRight(this.props.user)}
                    </div>

                </div>
            </div>
        )
    }
}
export default Body;