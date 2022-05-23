import React from 'react';
import { Link } from 'react-router-dom';

const multiNavbar = ({ data }) => {
    const renderMenuItems = data => {
        return data.map((item, index) =>
            (item?.children && item?.children.length) ? (<li key={index}><Link to={"#"}>{item.name}</Link><ul>
                {renderMenuItems(item.children)}
            </ul></li>
            ) : <li key={index}><Link to={item.url}>{item.name}</Link></li>
        )
    }
    return data && (
        <div>
            <ul>
                {renderMenuItems(data)}
            </ul>
        </div>
    );
}

export default multiNavbar;