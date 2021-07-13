using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HexGridGenerator {
    public GameObject parent;
    public GameObject HexCellPrefab;
    public int GridWidth = 3;
    public int GridDepth = 3;
    public int GridHeight = 1;
    public double TileDensity = 1;

    public void GenerateTiles(HexGrid grid) {
        System.Random rand = new System.Random();
        if(grid != null) {
            for (int gY = 0; gY < GridHeight; ++gY) {
                for (int gZ = 0; gZ < GridDepth; ++gZ) {
                    for (int gX = 0; gX < GridWidth; ++gX) {
                        if (rand.NextDouble() <= TileDensity) {
                            GameObject newTile = GameObject.Instantiate(HexCellPrefab, 
                                new Vector3(gX * grid.SpacingX, gY * grid.SpacingY, gZ * grid.SpacingZ + (gX % 2 == 0 ? 0 : grid.SpacingZ / 2)), 
                                new Quaternion(),
                                grid.transform
                            );
                            GameObject oldTile = null;
                            grid.SetHexTileByCoordinate(gX, gY, gZ, newTile, out oldTile);
                            if(oldTile != null) {
                                GameObject.Destroy(oldTile);
                            }
                        }
                    }
                }
            }
        }
    }
}
