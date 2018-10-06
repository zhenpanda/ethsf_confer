import React, {Component} from 'react';
import Header from './Header';
import Body from './Body';

class Trade extends Component {

    state = { currentSide: null } 

    displaySide() {
        
    }
    

    render() {
        return(
            <div className="container">

                <Header />
                <Body />
            
            </div>
        )
    }
}
export default Trade;