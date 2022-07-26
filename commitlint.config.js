module.exports = {
  extends: ['@commitlint/config-angular'],
  formatter: '@commitlint/format',
  defaultIgnores: true,
  helpUrl:
    'https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines',
  rules: {
    'type-enum': [2, 'always' ,['ci', 'docs', 'feat', 'fix', 'refactor', 'test', 'chore']],
  },
};