describe("Haskell upstream parser regressions", () => {
  let editor;

  beforeEach(async () => {
    await lumine.packages.activatePackage("language-haskell");
    editor = await lumine.workspace.open();
    editor.setGrammar(lumine.grammars.grammarForScopeName("source.haskell"));
  });

  afterEach(() => editor?.destroy());

  it("keeps type aliases available to the symbol query", async () => {
    editor.setText("type Name = String\n");
    expect(await editor.whenGrammarSettled()).toBe(true);
    const root = editor.getSyntaxNodeAtBufferPosition([0, 0], (node) => !node.parent);
    expect(root.hasError).toBe(false);
    const query = await editor.getGrammar().getQuery("tagsQuery");
    expect(
      query
        .captures(root)
        .filter((capture) => capture.name === "name")
        .map((capture) => capture.node.text),
    ).toContain("Name");
  });

  it("highlights the n-ary lambda cases keyword", async () => {
    editor.setText("f = \\cases\n  A x y -> x\n  _ _ -> 0\n");
    expect(await editor.whenGrammarSettled()).toBe(true);
    expect(editor.scopeDescriptorForBufferPosition([0, 6]).getScopesArray()).toContain(
      "keyword.control.conditional.haskell",
    );
  });
});
