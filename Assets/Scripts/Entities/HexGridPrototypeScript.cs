using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HexGridPrototypeScript : MonoBehaviour {
    public GameObject HexCellPrefab;
    public int GridWidth = 3;
    public int GridDepth = 3;
    public int GridHeight = 1;
    public double TileDensity = 1;

    void Start() {
        HexGridGenerator generator = new HexGridGenerator();
        generator.HexCellPrefab = HexCellPrefab;
        generator.GridWidth = GridWidth;
        generator.GridDepth = GridDepth;
        generator.GridHeight = GridHeight;
        generator.TileDensity = TileDensity;

        GameObject newGrid = new GameObject("Hex Grid");
        newGrid.transform.position = this.transform.position;
        HexGrid gridScript = newGrid.AddComponent<HexGrid>();
        generator.GenerateTiles(gridScript);
        
        Destroy(this.gameObject);
    }
}
