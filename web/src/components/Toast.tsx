import * as React from 'react';
import * as ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import './Toast.css';

interface ToastProps {
    children?: React.ReactChildren;
    visible: boolean;
}

const styles = {
    position: 'absolute',
    left: 0,
    top: 0,
    right: 0,
    backgroundColor: '#337ab7',
    padding: '5px',
    color: 'white',
};

export function Toast({ children, visible }: ToastProps) {
    return (
        <ReactCSSTransitionGroup
            transitionName='toast'
            transitionEnterTimeout={200}
            transitionLeaveTimeout={300}
        >
            {visible ? 
            <div style={styles} key={1}>
                {children}
            </div>
            : null}
        </ReactCSSTransitionGroup>
    );
}
