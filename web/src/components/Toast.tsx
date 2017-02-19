import * as React from 'react';

interface ToastProps {
    children?: React.ReactChildren;
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

export function Toast({ children }: ToastProps) {
    return (
        <div style={styles}>
            {children}
        </div>
    );
}
