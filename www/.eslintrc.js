module.exports = {
  extends: 'react-app',

  globals: {
    __PATH_PREFIX__: true,
  },

  rules: {
    'no-var': 'error', // No `var` plz - we are not savages anymore
    
    // Enforce absolute imports to be first
    'import/order': [
      'error',
      {
        groups: [
          ['builtin', 'external', 'internal'],
          ['parent', 'sibling', 'index'],
        ],
      },
    ],
  },
};
