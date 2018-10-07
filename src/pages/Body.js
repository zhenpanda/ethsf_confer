import React, {Component} from 'react';
import Wallet from './Wallet';
import WalletToo from './WalletToo';

class Body extends Component {

    displayOnExplorer(stage) {
        // console.log(stage)
        if(stage) {

            switch(stage) {
                case "first":
                    return(
                        <div>
                            <div className="send-proof moveFromTopFade delay100">
                                <div className="person">Sender: Alice</div>
                                <div className="amount">Sending Amount: 10</div>
                                <div className="amount">Receiver: Bob</div>
                            </div>
                        </div>
                    )
                case "second":
                    return(
                        <div>
                            <div className="send-proof moveFromTopFade delay100">
                                <div className="person">Sender: Alice</div>
                                <div className="amount">Sending Amount: 10</div>
                                <div className="amount">Receiver: Bob</div>
                            </div>
                            <div className="send-proof moveFromTopFade delay200">
                                <div className="person">Sender: Bob</div>
                                <div className="amount">Sending: Proof</div>
                                <div className="amount">Receiver: Alice</div>
                            </div>
                        </div>
                )     
                case "third":
                    return(
                        <div>
                            <div className="send-proof moveFromTopFade delay100">
                                <div className="person">Sender: Alice</div>
                                <div className="amount">Sending Amount: 10</div>
                                <div className="amount">Receiver: Bob</div>
                            </div>
                            <div className="send-proof moveFromTopFade delay200">
                                <div className="person">Sender: Bob</div>
                                <div className="amount">Sending: Proof</div>
                                <div className="amount">Receiver: Alice</div>
                            </div>
                            <div className="send-proof-final moveFromTopFade delay300">
                                <div className="amount">Proof From: Alice</div>
                                <div className="amount">Proof From: Bob</div>
                                <div className="person">Push on-Chain state change</div>
                            </div>
                        </div>
                )     
            }

        }

    }
    displayUserLeft(userState, stage) {
        // console.log(userState);
        if(userState === undefined || userState === "Alice") {
            if(stage !== "third") {
                return(
                    <Wallet 
                        display="visiable" 
                        balance="100"
                        proof={this.props.proof}
                        makeProof={this.props.makeProof}
                        moveStage={this.props.moveStage}
                        stage={this.props.stage}
                    />
                )
            }else{
                return(
                    <Wallet 
                        display="visiable" 
                        balance="90"
                        proof={this.props.proof}
                        makeProof={this.props.makeProof}
                        moveStage={this.props.moveStage}
                        stage={this.props.stage}
                    />
                )
            }
        }else if(userState === "Bob") {
            return(
                <Wallet 
                    display="none"
                    balance="100"
                />
            )
        }
    }
    displayUserRight(userState, stage) {
        if(userState === undefined || userState === "Alice") {
            return(
                <Wallet 
                    display="none"
                    balance="100"
                />
            )
        }else if(userState === "Bob") {
            if(stage !== "third") {
                return(
                    <WalletToo 
                        display="visiable" 
                        balance="5"
                        makeProofToo={this.props.makeProofToo}
                        prooftoo={this.props.prooftoo}
                        moveStage={this.props.moveStage}
                    />
                )
            }else{
                return(
                    <WalletToo 
                        display="visiable" 
                        balance="15"
                        makeProofToo={this.props.makeProofToo}
                        prooftoo={this.props.prooftoo}
                        moveStage={this.props.moveStage}
                    />
                )
            }

        }
    }

    render() {
        return(
            <div className="body">
                <div className="row">

                    <div className="col s4 m4">
                        {this.displayUserLeft(this.props.user, this.props.stage)}
                    </div>
                    
                    <div className="col s4 m4">
                        <div className="explorer">
                            {this.displayOnExplorer(this.props.stage)}
                        </div>
                    </div>
                    
                    <div className="col s4 m4">
                            {this.displayUserRight(this.props.user, this.props.stage)}
                    </div>

                </div>
            </div>
        )
    }
}
export default Body;