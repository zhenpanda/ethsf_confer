import React, {Component} from 'react';
import $ from 'jquery';

class Wallet extends Component {
    
    render() {

        if(this.props.display === "visiable") {
            return(
                <div className="wallet card">
                    <div className="head-piece moveFromBottomFade delay200">
                        <div className="row">
                            <div className="col s1 m1" />
                            <div className="col s8 m8">
                                <div className="top-text">Wallet Balance <span className="fa fa-caret-down" /></div>
                                <div className="mid-text">Token Amount: </div>
                            </div>
                            <div className="col s3 m3">
                                <div className="money-text"><span className="fa fa-circle" /> {this.props.balance}</div>
                            </div>
                        </div>
                    </div>
                    <div className="info">

                        <div className="input-block">
                            <div className="row">
                                <div className="col s1 m1" />
                                <div className="col s5 m5">
                                    <div className="input-text"><span className="fa fa-paper-plane-o icon" /> Send Amount:</div>
                                </div>
                                <div className="col s3 m3">
                                    <div className="input-area">
                                        <div className="input-field">
                                            <input />
                                        </div>
                                    </div>
                                </div>
                                <div className="col s4 m4" />
                            </div>
                        </div>
                        <div className="input-address">
                            <div className="row">
                                <div className="col s1 m1" />
                                <div className="col s5 m5">
                                    <div className="input-text"><span className="fa fa fa-address-book-o icon" /> Send Address:</div>
                                </div>
                                <div className="col s5 m5">
                                    <div className="input-area">
                                        <div className="input-field">
                                            <input />
                                        </div>
                                    </div>
                                </div>
                                <div className="col s1 m1" />
                            </div>
                        </div>

                    </div>
                    <div className="lower">
                    </div>
                </div>
            )
        }else if(this.props.display === "none") {
            return(
                <div className="hidden card" />
            )
        }
        

    }
}
export default Wallet;