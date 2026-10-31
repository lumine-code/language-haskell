describe("language-haskell editing defaults", () => {
  let editor;
  beforeEach(async () => {
    jasmine.useRealClock();
    await lumine.packages.activatePackage("language-source");
    await lumine.packages.activatePackage("language-haskell");
    await lumine.packages.activatePackage("bracket-matcher");

    editor = await lumine.workspace.open();
    editor.setGrammar(lumine.grammars.grammarForScopeName("source.haskell"));
    editor.setText("foldl' combine initial values");
    await editor.whenGrammarSettled();
  });
  afterEach(() => editor?.destroy());

  it("uses the correct comment operation in source.haskell", async () => {
    editor.setGrammar(lumine.grammars.grammarForScopeName("source.haskell"));
    editor.setText("foldl' combine initial values");
    await editor.whenGrammarSettled();
    await editor.toggleLineCommentsForBufferRows(0, editor.getLastBufferRow());
    await editor.whenGrammarSettled();
    expect(editor.lineTextForBufferRow(0)).toBe("-- foldl' combine initial values");
    await editor.toggleLineCommentsForBufferRows(0, editor.getLastBufferRow());
    await editor.whenGrammarSettled();
    expect(editor.getText()).toBe("foldl' combine initial values");
  });

  it("provides real block delimiters to snippet and comment consumers", async () => {
    const delimiters = await editor.getCommentDelimitersForBufferPosition([0, 0]);
    expect(delimiters.block).toEqual(["{-", "-}"]);
    expect(delimiters.line).toBe("--");
  });

  it("selects a complete language identifier without including adjacent syntax", () => {
    const index = editor.getText().indexOf("foldl'");
    editor.setCursorBufferPosition(editor.getBuffer().positionForCharacterIndex(index + 2));
    editor.selectWordsContainingCursors();
    expect(editor.getSelectedText()).toBe("foldl'");
  });
  it("keeps explicit user word-boundary overrides", () => {
    const options = { scopeSelector: ".source.haskell" };
    try {
      lumine.config.set("editor.nonWordCharacters", "'", options);
      const index = editor.getText().indexOf("foldl'");
      editor.setCursorBufferPosition(editor.getBuffer().positionForCharacterIndex(index + 2));
      editor.selectWordsContainingCursors();
      expect(editor.getSelectedText()).not.toBe("foldl'");
    } finally {
      lumine.config.unset("editor.nonWordCharacters", options);
    }
  });

  it("does not add a closing apostrophe while typing a promoted constructor", async () => {
    editor.setText("");
    await editor.whenGrammarSettled();
    for (const character of "'Just") await editor.insertText(character);
    await editor.whenGrammarSettled();
    expect(editor.getText()).toBe("'Just");
    editor.setText("type Result = 'Just Bool");
    await editor.whenGrammarSettled();
    expect(
      editor.getSyntaxNodeAtBufferPosition([0, 15], (node) => node.type === "promoted")?.text,
    ).toBe("'Just");
    editor.setText("type Values = ");
    await editor.whenGrammarSettled();
    editor.setCursorBufferPosition([0, Infinity]);
    for (const character of "'[Int, Bool]") await editor.insertText(character);
    await editor.whenGrammarSettled();
    expect(editor.getText()).toBe("type Values = '[Int, Bool]");
  });

  it("keeps a manually typed character literal valid", async () => {
    editor.setText("value = ");
    await editor.whenGrammarSettled();
    editor.setCursorBufferPosition([0, Infinity]);
    for (const character of "'x'") await editor.insertText(character);
    await editor.whenGrammarSettled();
    expect(editor.getText()).toBe("value = 'x'");
    expect(editor.getSyntaxNodeAtBufferPosition([0, 9], (node) => node.type === "char")?.text).toBe(
      "'x'",
    );
  });
});
