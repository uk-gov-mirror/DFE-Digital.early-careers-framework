describe("Admin user deleting delivery partner", () => {
  const deliveryPartnerName = "Delivery Partner 1";

  beforeEach(() => {
    cy.login("admin");
  });

  it("should delete a new delivery partner", () => {
    cy.appScenario("admin/suppliers/manage_delivery_partner");

    cy.visit("/admin/suppliers");
    cy.get("a").contains(deliveryPartnerName).click();

    cy.location("pathname").should(
      "contain",
      "/admin/suppliers/delivery-partner"
    );
    cy.get(".govuk-button").contains("Delete").click();

    cy.location("pathname").should("contain", "/delete");
    cy.get("main").should("contain", deliveryPartnerName);
    cy.get(".govuk-button").contains("Delete").click();

    cy.location("pathname").should("equal", "/admin/suppliers");
    cy.get("main").should("not.contain", deliveryPartnerName);
  });
});