using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hex {
    public HexMap map;
    public float height;
    public Vector2Int coordinate;
    public Vector2Int texCoord;

    public Hex() : this(Vector2Int.zero, 0, null, new Vector2Int(0, 0)) {}

    public Hex(Vector2Int coord, float h) : this(coord, h, null, new Vector2Int(0, 0)) {}
    
    public Hex(Vector2Int coord, float h, HexMap map) : this(coord, h, null, new Vector2Int(0, 0)) {}

    public Hex(Vector2Int coord, float h, HexMap map, Vector2Int texCoord) {
        coordinate = coord;
        height = h;
        this.map = map;
        this.texCoord = texCoord;
    }

    public Hex NeighborN() {
        if(map != null) {
            return map.CellAt(coordinate.x, coordinate.y + 1);
        }
        return null;
    }

    public Hex NeighborNE() {
        if (map != null) {
            if (Mathf.Abs(coordinate.x) % 2 == 0) {
                return map.CellAt(coordinate.x + 1, coordinate.y);
            } else {
                return map.CellAt(coordinate.x + 1, coordinate.y + 1);
            }
        }
        return null;
    }

    public Hex NeighborSE() {
        if (map != null) {
            if(Mathf.Abs(coordinate.x) % 2 == 0) {
                return map.CellAt(coordinate.x + 1, coordinate.y - 1);
            } else {
                return map.CellAt(coordinate.x + 1, coordinate.y);
            }
        }
        return null;
    }

    public Hex NeighborS() {
        if (map != null) {
            return map.CellAt(coordinate.x, coordinate.y - 1);
        }
        return null;
    }

    public Hex NeighborSW() {
        if (map != null) {
            if (Mathf.Abs(coordinate.x) % 2 == 0) {
                return map.CellAt(coordinate.x - 1, coordinate.y - 1);
            } else {
                return map.CellAt(coordinate.x - 1, coordinate.y);
            }
        }
        return null;
    }

    public Hex NeighborNW() {
        if (map != null) {
            if (Mathf.Abs(coordinate.x) % 2 == 0) {
                return map.CellAt(coordinate.x - 1, coordinate.y);
            } else {
                return map.CellAt(coordinate.x - 1, coordinate.y + 1);
            }
        }
        return null;
    }

    public Hex[] Neighbors() {
        return Neighbors(false);
    }

    public Hex[] Neighbors(bool includeNull) {
        if(includeNull) {
            return new Hex[] {
                NeighborNE(), NeighborN(), NeighborNW(), NeighborSW(), NeighborS(), NeighborSE()
            };
        } else {
            List<Hex> result = new List<Hex>();
            Hex h;
            h = NeighborNE();
            if (h != null) result.Add(h);
            h = NeighborN();
            if (h != null) result.Add(h);
            h = NeighborNW();
            if (h != null) result.Add(h);
            h = NeighborSW();
            if (h != null) result.Add(h);
            h = NeighborS();
            if (h != null) result.Add(h);
            h = NeighborSE();
            if (h != null) result.Add(h);

            return result.ToArray();
        }
    }

    public Hex[] Neighbors(int radius) {
        List<Hex> complete = new List<Hex>();
        List<Hex> found = new List<Hex>();
        List<Hex> next = new List<Hex>();
        
        if(radius >= 1) {
            found.AddRange(this.Neighbors()); // Add immediate neighbors
            for (int i = 2; i <= radius; ++i) {
                while(found.Count > 0) {
                    foreach(Hex h in found[0].Neighbors()) {
                        if(!complete.Contains(h) && !found.Contains(h) && !next.Contains(h) && h != this) {
                            next.Add(h);
                        }
                    }
                    complete.Add(found[0]);
                    found.RemoveAt(0);
                }
                found = new List<Hex>(next);
                next.Clear();
            }
        }
        
        return complete.ToArray();
    }

    public Hex StepToward(Hex target) {
        bool even = Mathf.Abs(this.coordinate.x) % 2 == 0;
        if(target.coordinate.y < this.coordinate.y) {
            if(target.coordinate.x < this.coordinate.x) {
                return this.NeighborSW();
            } else if(target.coordinate.x == this.coordinate.x) {
                return this.NeighborS();
            } else {
                return this.NeighborSE();
            }
        } else if(target.coordinate.y == this.coordinate.y) {
            if (target.coordinate.x < this.coordinate.x) {
                if(even) {
                    return this.NeighborNW();
                } else {
                    return this.NeighborSW();
                }
            } else if (target.coordinate.x == this.coordinate.x) {
                return target;
            } else {
                if (this.coordinate.x % 2 == 0) {
                    return this.NeighborNE();
                } else {
                    return this.NeighborSE();
                }
            }
        } else {
            if (target.coordinate.x < this.coordinate.x) {
                return this.NeighborNW();
            } else if (target.coordinate.x == this.coordinate.x) {
                return this.NeighborN();
            } else {
                return this.NeighborNE();
            }
        }
    }

    public int DistanceTo(Hex target) { 
        if(target == null) return 0;
        if (target == this) return 0;
        if (target.map != this.map || this.map == null) return 0;
        if (target.coordinate == this.coordinate) return 0;

        Hex step = this;
        int count = 0;

        do {
            step = step.StepToward(target);
            ++count;
        } while (step != null && step != target && count < 5000);
        return count;

        /*
        int result = 0;
        if(target == this) {
            result = 0;
        } else {
            if(target.map == null || target.map != this.map) {
                result = 0;
            } else {

                int yChange = 0;
                for(int xChange = 0; xChange < Mathf.Abs(target.coordinate.x - this.coordinate.x); ++xChange) {
                    
                }


                int distX = Mathf.Abs(target.coordinate.x - this.coordinate.x);
                int distY = Mathf.Abs(target.coordinate.y - this.coordinate.y);
                //distY = Mathf.Clamp(distY - (distX / 2), 0, int.MaxValue);
                if(target.coordinate.y == this.coordinate.y) {
                    result = distX;
                } else if(target.coordinate.y > this.coordinate.y) {
                    if(Mathf.Abs(this.coordinate.x % 2) == 0) {

                    } else {

                    }
                } else if(target.coordinate.y < this.coordinate.y) {

                }
            }
        }
        return result;
        */
    }
}
