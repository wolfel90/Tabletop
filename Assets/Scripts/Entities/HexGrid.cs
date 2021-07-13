using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HexGrid : MonoBehaviour {
    private Dictionary<int, Dictionary<int, Dictionary<int, GameObject>>> Tiles = new Dictionary<int, Dictionary<int, Dictionary<int, GameObject>>>(); // X > Z > Y : Data stored in "stacks"
    public float SpacingX = 0.75F;
    public float SpacingY = 0.25F;
    public float SpacingZ = 0.866025F;

    // Start is called before the first frame update
    void Start() {

    }

    // Update is called once per frame
    void Update() {
        
    }

    public GameObject GetHexTileByCoordinate(int x, int y, int z) {
        if(Tiles.ContainsKey(x)) {
            if(Tiles[x].ContainsKey(z)) {
                if(Tiles[x][z].ContainsKey(y)) {
                    return Tiles[x][z][y];
                }
            }
        }
        return null;
    }

    public GameObject GetHexTileByCoordinate(Vector3Int coord) {
        if (Tiles.ContainsKey(coord.x)) {
            if (Tiles[coord.x].ContainsKey(coord.z)) {
                if (Tiles[coord.x][coord.z].ContainsKey(coord.y)) {
                    return Tiles[coord.x][coord.z][coord.y];
                }
            }
        }
        return null;
    }

    public Vector3Int GetTopCoordinateInStack(int x, int z) {
        if(Tiles.ContainsKey(x)) {
            if(Tiles[x].ContainsKey(z)) {
                int top = -1;
                foreach (int y in Tiles[x][z].Keys) {
                    if (y > top) {
                        top = y;
                    }
                }
                if (top >= 0) {
                    return new Vector3Int(x, top, z);
                }
            }
        }
        return new Vector3Int(x, -1, z);
    }

    public GameObject GetTopTileInStack(int x, int z) {
        if(Tiles.ContainsKey(x)) {
            if(Tiles[x].ContainsKey(z)) {
                int top = -1;
                foreach(int y in Tiles[x][z].Keys) {
                    if(y > top) {
                        top = y;
                    }
                }
                if(top >= 0) {
                    return Tiles[x][z][top];
                }
            }
        }
        return null;
    }

    public void SetHexTileByCoordinate(int x, int y, int z, GameObject tile) {
        SetHexTileByCoordinate(x, y, z, tile, out GameObject dummy);
        if(dummy != null) {
            GameObject.Destroy(dummy);
        }
    }

    public bool IsCellOccupied(int x, int y, int z) {
        return IsCellOccupied(new Vector3Int(x, y, z));
    }

    public bool IsCellOccupied(Vector3Int coord) {
        if (Tiles.ContainsKey(coord.x)) {
            if (Tiles[coord.x].ContainsKey(coord.z)) {
                if (Tiles[coord.x][coord.z].ContainsKey(coord.y)) {
                    return true;
                }
            }
        }
        return false;
    }

    public void SetHexTileByCoordinate(int x, int y, int z, GameObject tile, out GameObject oldTile) {
        oldTile = GetHexTileByCoordinate(x, y, z);
        if(oldTile != null) {
            RemoveHexTileByCoordinate(x, y, z);
        }
        if(tile == null) {
            RemoveHexTileByCoordinate(x, y, z);
        } else {
            if (!Tiles.ContainsKey(x)) Tiles.Add(x, new Dictionary<int, Dictionary<int, GameObject>>());
            if (!Tiles[x].ContainsKey(z)) Tiles[x].Add(z, new Dictionary<int, GameObject>());
            if (!Tiles[x][z].ContainsKey(y)) Tiles[x][z].Add(y, tile);
            tile.transform.position = new Vector3(x * SpacingX, y * SpacingY, z * SpacingZ + (x % 2 == 0 ? 0 : SpacingZ / 2));
            tile.gameObject.GetComponent<HexTile>().ParentGrid = this;
            tile.gameObject.GetComponent<HexTile>().GridPosition = new Vector3Int(x, y, z);

            Vector3Int[] neighbors = SurroundingTiles(tile);
            foreach(Vector3Int v in neighbors) {
                GameObject n = GetHexTileByCoordinate(v);
                if(n != null) {
                    if(IsTileEnclosed(n)) {
                        n.SetActive(false);
                    } else {
                        n.SetActive(true);
                    }
                }
            }

            if(IsTileEnclosed(tile)) {
                tile.SetActive(false);
            }
        }
    }

    public void RemoveHexTileByCoordinate(int x, int y, int z) {
        RemoveHexTileByCoordinate(x, y, z, out GameObject dummy);
        if(dummy != null) {
            GameObject.Destroy(dummy);
        }
    }

    public void RemoveHexTileByCoordinate(int x, int y, int z, out GameObject oldTile) {
        oldTile = GetHexTileByCoordinate(x, y, z);
        if(Tiles.ContainsKey(x)) {
            if(Tiles[x].ContainsKey(z)) {
                if(Tiles[x][z].ContainsKey(y)) {
                    Tiles[x][z].Remove(y);
                }
                if (Tiles[x][z].Count == 0) Tiles[x].Remove(z);
            }
            if(Tiles[x].Count == 0) {
                Tiles.Remove(x);
            }
        }
    }

    private Vector3Int[] SurroundingTiles(GameObject tile) {
        if(tile.GetComponent<HexTile>().ParentGrid == this) {
            return SurroundingTiles(tile.GetComponent<HexTile>().GridPosition);
        } else {
            return null;
        }
    }

    private Vector3Int[] SurroundingTiles(int x, int y, int z) {
        return SurroundingTiles(new Vector3Int(x, y, z));
    }

    private Vector3Int[] SurroundingTiles(Vector3Int coord) {
        Vector3Int[] result = new Vector3Int[8];

        if(coord.x % 2 == 0) {
            result[0] = new Vector3Int(coord.x + 1, coord.y, coord.z - 1);
            result[1] = new Vector3Int(coord.x + 1, coord.y, coord.z);
            result[2] = new Vector3Int(coord.x - 1, coord.y, coord.z - 1);
            result[3] = new Vector3Int(coord.x - 1, coord.y, coord.z);
        } else {
            result[0] = new Vector3Int(coord.x + 1, coord.y, coord.z);
            result[1] = new Vector3Int(coord.x + 1, coord.y, coord.z + 1);
            result[2] = new Vector3Int(coord.x - 1, coord.y, coord.z);
            result[3] = new Vector3Int(coord.x - 1, coord.y, coord.z + 1);
        }
        result[4] = new Vector3Int(coord.x, coord.y, coord.z + 1);
        result[5] = new Vector3Int(coord.x, coord.y, coord.z - 1);
        result[6] = new Vector3Int(coord.x, coord.y + 1, coord.z);
        result[7] = new Vector3Int(coord.x, coord.y - 1, coord.z);

        return result;
    }

    public Vector2Int[] GetStacksInRadius(Vector2Int origin, int radius) {
        List<Vector2Int> done = new List<Vector2Int>();
        if (origin != null && radius > 0) {
            List<Vector2Int> current = new List<Vector2Int>();
            List<Vector2Int> next = new List<Vector2Int>();

            current.Add(origin);
            for(int step = 0; step < radius; ++step) {
                while (current.Count > 0) {
                    Vector2Int[] ring = GetNeighborStacks(current[0]);
                    foreach(Vector2Int v in ring) {
                        if(!done.Contains(v) && !current.Contains(v) && !next.Contains(v)) {
                            next.Add(v);
                        }
                    }
                    done.Add(current[0]);
                    current.RemoveAt(0);
                }
                current = new List<Vector2Int>(next);
                next.Clear();
            }
        }
        
        return done.ToArray();
    }

    public Vector2Int[] GetNeighborStacks(Vector2Int origin) {
        if(origin.x % 2 == 0) {
            return new Vector2Int[] {
                new Vector2Int(origin.x + 1, origin.y - 1),
                new Vector2Int(origin.x + 1, origin.y),
                new Vector2Int(origin.x, origin.y - 1),
                new Vector2Int(origin.x, origin.y + 1),
                new Vector2Int(origin.x - 1, origin.y - 1),
                new Vector2Int(origin.x - 1, origin.y)
            };
        } else {
            return new Vector2Int[] {
                new Vector2Int(origin.x + 1, origin.y),
                new Vector2Int(origin.x + 1, origin.y + 1),
                new Vector2Int(origin.x, origin.y - 1),
                new Vector2Int(origin.x, origin.y + 1),
                new Vector2Int(origin.x - 1, origin.y),
                new Vector2Int(origin.x - 1, origin.y + 1)
            };
        }
        
    }

    private bool IsTileEnclosed(GameObject tile) {
        if(tile.GetComponent<HexTile>()?.ParentGrid == this) {
            return IsTileEnclosed(tile.GetComponent<HexTile>().GridPosition);
        }
        return false;
    }
    
    private bool IsTileEnclosed(int x, int y, int z) {
        return IsTileEnclosed(new Vector3Int(x, y, z));
    }

    private bool IsTileEnclosed(Vector3Int coord) {
        Vector3Int[] neighbors = SurroundingTiles(coord);
        foreach(Vector3Int v in neighbors) {
            if (!IsCellOccupied(v)) return false;
        }
        return true;
    }
}
