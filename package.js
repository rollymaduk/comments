Package.describe({
  name: 'rollypolly:comments',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: 'A comments package for meteor models',
  // URL to the Git repository containing the source code for this package.
  git: 'https://github.com/rollymaduk/comments',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.use('jquery');
  api.use('coffeescript');
  api.use('reactive-var');
  api.use('templating','client');
  api.use('aldeed:simple-schema');
  api.use('aldeed:autoform');
  api.use('gwendall:body-events','client');
  api.use('gfk:server-messages');
  api.use('zimme:collection-timestampable');
  api.export('Rp_Comment');
  api.addFiles(['common/base.coffee','common/model.coffee']);
  api.addFiles(['client/ui/comments-input.html','client/ui/comments.html'],'client');
  api.addFiles(['client/ui/helper.coffee','client/ui/comments.coffee'],'client');
  api.addFiles(['client/comments.coffee'],'client');
  api.addFiles(['server/comments.coffee'],'server');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('rollypolly:comments');
  api.addFiles('comments-tests.js');
});
