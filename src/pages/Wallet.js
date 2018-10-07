import React, {Component} from 'react';
import { Scrollbars } from 'react-custom-scrollbars';
import { SyncLoader } from 'react-spinners';

class Wallet extends Component {
    
    state = {loading: null}

    showAnim(makeProof) {
        this.setState({loading: true});
        setTimeout(() => {
            this.setState({loading: null});
            makeProof();
        },3000)
    }

    displaySendProof(makeProof) {
        return(
            <div className="info moveFromTopFade delay300">
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
                        <div className="col s6 m6">
                            <div className="input-area">
                                <div className="input-field">
                                    <input />
                                </div>
                            </div>
                        </div>
                        <div className="col s1 m1" />
                    </div>
                </div>
                <div className="btn-options-area">
                    <div className="row">
                        <div className="col s1 m1" />
                        <div className="col s5 m5">
                            <div className="create-proof-btn"
                            onClick={() => this.showAnim(makeProof)}>Create Proof Data</div>
                        </div>
                        <div className="col s5 m5">
                            <div className="create-send-btn">Send Tx Msg</div>
                        </div> 
                        <div className="col s1 m1" /> 
                    </div>
                </div>
            </div>
        )
    }
    displayRecivedData(proof) {
        // console.log(proof);
        if(proof) {
            return(
                <div className="lower">
                    <Scrollbars
                        autoHide
                        autoHideTimeout={1000}
                        autoHideDuration={200}
                        autoHeight
                        autoHeightMin={0}
                        autoHeightMax={255}
                        
                        thumbMinSize={30}
                        universal={true}>
                        
                        <div className="proof-data moveFromTopFade delay80">{proof}</div>

                    </Scrollbars>
                </div>
            )
        }else{
            <div />
        }
    }

    render() {

        if(this.props.display === "visiable") {
            
            return(
                <div className="wallet card">
            
                <div className='sweet-loading'>
                    <SyncLoader
                        sizeUnit={"px"}
                        size={35}
                        color={'#2ca6d6'}
                        loading={this.state.loading}
                    />
                </div> 

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

                    {this.displaySendProof(this.props.makeProof)}

                    {this.displayRecivedData(this.props.proof)}

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