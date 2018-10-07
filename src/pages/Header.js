import React, {Component} from 'react';

// import $ from 'jquery';

import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

class Header extends Component {

    copyAddress(inputName) {
        if(inputName === "Alice") {
            navigator.clipboard.writeText("0x6c32931E748f2f1098BC934cb8De0bCb5696E1f6");    
        }else{
            navigator.clipboard.writeText("0x24e6429ad5d8d1efc64f03ada043fdbd5a405cd23f40264ddd6dbce28863554c");
        }
        toast.info("Address Copied!", {
            position: toast.POSITION.TOP_RIGHT
        });
    }
    displayUserLeft(userState) {
        // console.log(userState);
        if(userState === undefined || userState === "Alice") {
            return(
                <div className="section moveFromTopFade delay100 target">
                    <div className="name" onClick={() => this.props.switchUser("Alice")}>Alice's Wallet 
                    <span className="fa fa-address-book-o icon" onClick={() => this.copyAddress("Alice")} />
                    </div>
                </div>
            )
        }else if(userState === "Bob") {
            return(
                <div className="section moveFromTopFade delay100">
                    <div className="name" onClick={() => this.props.switchUser("Alice")}>Alice's Wallet 
                    <span className="fa fa-address-book-o icon" onClick={() => this.copyAddress("Alice")} />
                    </div>
                </div>
            )
        }
    }
    displayUserRight(userState) {
        if(userState === undefined || userState === "Alice") {
            return(
                <div className="section moveFromTopFade delay100">
                    <div className="name">
                        <span onClick={() => this.props.switchUser("Bob")}>Bob's Wallet</span> 
                        <span className="fa fa-address-book-o icon" onClick={() => this.copyAddress("Bob")} />
                    </div>
                </div>
            )
        }else if(userState === "Bob") {
            return(
                <div className="section moveFromTopFade delay100 target">
                    <div className="name">
                        <span onClick={() => this.props.switchUser("Bob")}>Bob's Wallet</span> 
                        <span className="fa fa-address-book-o icon" onClick={() => this.copyAddress("Bob")} />
                    </div>
                </div>
            )
        }
    }
    
    render() {
        return(
            <div className="header">
                <ToastContainer />
                <div className="row">


                    <div className="col s4 m4">
                        {this.displayUserLeft(this.props.user)}       
                    </div>
                    
                    <div className="col s4 m4">
                        <div className="mid-section moveFromTopFade delay200">
                            <div className="label">Transaction Explorer</div>
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
export default Header;