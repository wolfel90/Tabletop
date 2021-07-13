using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HexMap : Dictionary<int, Dictionary<int, Hex>> {
    private int minXExtent;
    private int maxXExtent;
    private int minZExtent;
    private int maxZExtent;
    public int minX { get { return minXExtent; } }
    public int maxX { get { return maxXExtent; } }
    public int minZ { get { return minZExtent; } }
    public int maxZ { get { return maxZExtent; } }
    private int width { get { return maxXExtent - minXExtent; } }
    private int depth { get { return maxZExtent - minZExtent; } }

    public HexMap() {
        minXExtent = int.MaxValue;
        maxXExtent = int.MinValue;
        minZExtent = int.MaxValue;
        maxZExtent = int.MinValue;
    }

    public void CreateCell(int x, int z) {
        SetCellHeight(0, x, z);
    }

    public void SetCellHeight(float height, int x, int z) {
        if (!this.ContainsKey(x)) Add(x, new Dictionary<int, Hex>());
        if (this[x].ContainsKey(z)) {
            this[x][z].map = null;
            this[x].Remove(z);
        }
        this[x].Add(z, new Hex(new Vector2Int(x, z), height, this));
        if (x < minXExtent) minXExtent = x;
        if (x > maxXExtent) maxXExtent = x;
        if (z < minZExtent) minZExtent = z;
        if (z > maxZExtent) maxZExtent = z;
    }

    public void SetCellAt(int x, int z, Hex h) {
        if (!this.ContainsKey(x)) Add(x, new Dictionary<int, Hex>());
        if(this[x].ContainsKey(z)) {
            this[x][z].map = null;
            this[x].Remove(z);
        }
        h.coordinate.x = x;
        h.coordinate.y = z;
        h.map = this;
        this[x].Add(z, h);
        if (x < minXExtent) minXExtent = x;
        if (x > maxXExtent) maxXExtent = x;
        if (z < minZExtent) minZExtent = z;
        if (z > maxZExtent) maxZExtent = z;
    }

    public Hex CellAt(int x, int z) {
        if(this.ContainsKey(x)) {
            if(this.ContainsKey(z)) {
                return this[x][z];
            }
        }
        return null;
    }

    public Hex CellAt(Vector2Int pos) {
        if (this.ContainsKey(pos.x)) {
            if (this.ContainsKey(pos.y)) {
                return this[pos.x][pos.y];
            }
        }
        return null;
    } 

    public bool GetCellCoordinate(Hex cell, out Vector2Int coord) {
        foreach(int x in this.Keys) {
            foreach(int z in this[x].Keys) {
                if(this[x][z] == cell) {
                    coord = new Vector2Int(x, z);
                    return true;
                }
            }
        }
        coord = new Vector2Int();
        return false;
    }

    public static HexMap GenerateRandomMap(int width, int depth, float minHeight, float maxHeight) {
        HexMap result = new HexMap();
        Hex h;
        System.Random r = new System.Random();

        for(int iZ = 0; iZ < depth; ++iZ) {
            for(int iX = 0; iX < width; ++iX) {
                
                if(iX == 0 || iZ == 0 || iX == width - 1 || iZ == depth - 1) {
                    // Border cells, lock to height = 0
                    //h = new Hex(new Vector2Int(iX, iZ), 0, result, new Vector2Int(Random.Range(0, 3), 0));
                    h = new Hex(new Vector2Int(iX, iZ), 0, result, new Vector2Int(0, 0));
                } else {
                    //h = new Hex(new Vector2Int(iX, iZ), Random.Range(minHeight, maxHeight), result, new Vector2Int(Random.Range(0, 3), 0));
                    h = new Hex(new Vector2Int(iX, iZ), Random.Range(minHeight, maxHeight), result, new Vector2Int(0, 0));
                }
                result.SetCellAt(iX, iZ, h);

            }
        }

        return result;
    }
}
