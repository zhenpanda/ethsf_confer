import React, {Component} from 'react';
import { Link } from 'react-router-dom'; 

class Home extends Component {
    render() {
        return(
            <div className="container">
            <div className="bg-wrapper">
                <div className="row">
                    <div className="col s8 m8" />
                    <div className="col s4 m4">
                        <div className="title">[ Confer ]</div>
                        <div className="details">On-chain Confidential transactions with smart contracts.</div>
                        <Link to="/trade">
                            <div className="light-blue darken-3 btn enter">Enter</div>
                        </Link>
                    </div>
                </div>
            </div>
            </div>
        )
    }
}
export default Home;