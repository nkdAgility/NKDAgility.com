const searchClient = algoliasearch("RSKJJ82EIK", "8b32e7e6c23096e5e958ddc581c14aee");

const search = instantsearch({
  indexName: "pages",
  searchClient,
});

search.addWidgets([
  instantsearch.widgets.searchBox({
    container: "#searchbox",
  }),

  instantsearch.widgets.hits({
    container: "#hits",
    templates: {
      item: `
            <article>
          <p>Name: {{#helpers.highlight}}{ "attribute": "title", "highlightedTagName": "mark" }{{/helpers.highlight}}</p>
        </article>
          `,
    },
  }),
  instantsearch.widgets.refinementList({
    container: "#refinement",
    attribute: "company",
  }),
]);

search.start();
