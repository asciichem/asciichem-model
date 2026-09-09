// Generated from schemas/v1/identifier.yaml — do not edit; regenerate.
export interface Identifier {
  readonly type: "identifier";
  readonly value: string;
  readonly convention: "cas" | "inchi" | "inchikey" | "smiles" | "canonical-smiles" | "iupac-name" | "pubchem-cid" | "chebi";
  readonly dictRef?: string;
}
