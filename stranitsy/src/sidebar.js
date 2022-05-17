import React from 'react';

import {Navigation} from 'react-minimal-side-navigation';
import 'react-minimal-side-navigation/lib/ReactMinimalSideNavigation.css';

function Sidebar() {
    return (
        <Navigation
            // you can use your own router's api to get pathname
            activeItemId="/management/members"
            onSelect={({itemId}) => {
                // history.push(itemId);
            }}
            items={[
                {
                title: 'Book',
                itemId: '/Book',
                subNav: [
                    {
                    title: 'Page1',
                    itemId: '/Book/Page1',
                    subNav: [
                        {
                            title: 'Page1.1',
                            itemId: '/Book/Page1/Page1.1',
                        }
                    ],
                    },
                    {
                    title: 'Members',
                    itemId: '/Book/members',
                    },
                ],
                },
                {
                title: 'Management',
                itemId: '/management',
                // elemBefore: () => <Icon name="users" />,
                subNav: [
                    {
                    title: 'Projects',
                    itemId: '/management/projects',
                    },
                    {
                    title: 'Members',
                    itemId: '/management/members',
                    },
                ],
                },
                {
                title: 'Another Item',
                itemId: '/another',
                subNav: [
                    {
                    title: 'Teams',
                    itemId: '/management/teams',
                    },
                ],
                },
            ]}
        />
    )
}

export default Sidebar;