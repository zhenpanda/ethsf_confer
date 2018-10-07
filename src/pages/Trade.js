import React, {Component} from 'react';

import {connect} from 'react-redux';
import * as actions from '../actions/index';

import Header from './Header';
import Body from './Body';

class Trade extends Component {

    displaySide() {
    }   

    render() {
        return(
            <div className="container">

                <Header />
                <Body 
                    proof={this.props.proof}
                    makeProof={this.props.makeProof}
                />
            
            </div>
        )
    }
}
function mapStateToProps(state) {
    console.log(state);
    return {
        proof: state.test.data
    }
  }
  export default connect(mapStateToProps, actions)(Trade);