const searchClient = algoliasearch("RSKJJ82EIK", "8b32e7e6c23096e5e958ddc581c14aee");

const search = instantsearch({
  indexName: "NKDA-WEB-nkdagility_com_pages",
  searchClient,
});

search.addWidgets([
  instantsearch.widgets.searchBox({ container: "#searchbox" }),
  instantsearch.widgets.refinementList({
    container: "#refinements",
    attribute: "keywords",
    searchable: true, // optional: makes the refinement list searchable
    sortBy: ["name:asc"], // optional: sorts refinements alphabetically
  }),
  instantsearch.widgets.hits({
    container: "#hits",
    templates: {
      item(hit) {
        console.log(hit);
        return `
          <article>
            <h2><a href="${hit.objectID}">${hit.title}</a></h2>
            <p>${hit.description}</p>
            <p><strong>Keywords:</strong>${hit.keywords}</p>
          </article>
        `;
      },
    },
  }),
]);

search.start();
