import React, {Component} from 'react';

class Header extends Component {

    render() {
        return(
            <div className="header">
                <div className="row">
                
                    <div className="col s4 m4">
                        <div className="section moveFromTopFade delay100 target">
                            <div className="name">Alice's Wallet <span className="fa fa-address-book-o icon" /></div>
                        </div>
                    </div>
                    
                    <div className="col s4 m4">
                        <div className="mid-section moveFromTopFade delay200">
                            <div className="label">Transaction Explorer</div>
                        </div>  
                    </div>

                    <div className="col s4 m4">
                        <div className="section moveFromTopFade delay100">
                            <div className="name">Bob's Wallet <span className="fa fa-address-book-o icon" /></div>
                        </div>
                    </div>

                </div>
            </div>
        )
    }
}
export default Header;