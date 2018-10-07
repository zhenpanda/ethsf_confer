import React, {Component} from 'react';
import Wallet from './Wallet';

class Body extends Component {

    render() {
        return(
            <div className="body">
                <div className="row">

                    <div className="col s4 m4">
                        <Wallet 
                            display="visiable" 
                            balance="100"
                            proof={this.props.proof}
                            makeProof={this.props.makeProof}
                        />
                    </div>
                    
                    <div className="col s4 m4">
                        <div className="explorer">
                        </div>
                    </div>
                    
                    <div className="col s4 m4">
                        <Wallet 
                            display="none"
                            balance="100"
                        />
                    </div>

                </div>
            </div>
        )
    }
}
export default Body;