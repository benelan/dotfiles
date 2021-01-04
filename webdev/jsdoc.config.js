module.exports = {
  tags: {
    allowUnknownTags: true,
    dictionaries: ['jsdoc', 'closure'],
  },
  source: {
    include: ['pages', 'utils', 'components'],
    includePattern: '.+\\.js(doc|x)?$',
    excludePattern: '(^|\\/|\\\\)_',
  },
  plugins: ['plugins/markdown'],
  opts: {
    destination: 'docs',
    recurse: true,
    readme: './README.md',
  },
}
