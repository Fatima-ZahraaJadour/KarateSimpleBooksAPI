function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  var DataStorage = Java.type('helpers.DataStorage');
  var dS = new DataStorage();
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    baseUrl: 'https://simple-books-api.glitch.me',
    email: dS.generate(),
    token: dS.read('token'),
    bookId: dS.readInt('id'),
    orderId: dS.read('orderId'),
    write: function (args) {
      return dS.write(args);
    }
  }
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  return config;
}
