module.exports = {
  ignorePatterns: ["build", "dist", "docs", "node_modules", ".next", ".cache"],
  extends: [
    "eslint:recommended",
    "plugin:prettier/recommended",
    // "airbnb-base",
    // "airbnb-typescript/base",
  ],
  env: {
    browser: true,
    es6: true,
    node: true,
  },
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: "module"
    // project: './tsconfig-eslint.json'
  },
  rules: {},
};
