exports.activate = function () {};

exports.consumeHyperlinkInjection = (hyperlink) => {
  return hyperlink.addInjectionPoint("source.haskell", {
    types: ["comment"],
  });
};

exports.consumeTodoInjection = (todo) => {
  return todo.addInjectionPoint("source.haskell", {
    types: ["comment"],
  });
};
