// Generated from schemas/v1/electron-configuration.yaml — do not edit; regenerate.
export interface ElectronConfiguration {
  readonly type: "electron-configuration";
  readonly orbitals: {
    orbital: string;
    occupancy: string;
  }[];
  readonly termSymbol?: {
    multiplicity?: string;
    letter?: string;
    jValue?: string;
  };
}
