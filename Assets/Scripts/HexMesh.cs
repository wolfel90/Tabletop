using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HexMesh : MonoBehaviour {
    private enum Direction { NE, N, NW, SW, S, SE }

    public int TileDivisions = 1;
    private float UVUnit { get { return 1f / (float)TileDivisions; } }
    public float SpacingX = 0.75F;
    public float SpacingZ = 0.866025F;
    public float Scalar = 1f;
    private float CartGridWidth { get { return Scalar / 4f; } } // One quarter of hexagon vertex-center-vertex measure
    private float CartGridDepth { get { return Scalar * Mathf.Sqrt(3f) / 4f; } } // One half of hexagon height

    private Mesh _surfaceMesh;
    public Mesh surfaceMesh { get { return _surfaceMesh; } }
    private Mesh _wallMesh;
    public Mesh wallMesh { get { return _wallMesh; } }

    private HexMap hexes = new HexMap();
    public HexMap map { get { return hexes; } }

    private Transform wall;
    private Transform surface;
    
    private VertexMap surfaceVerts = new VertexMap();
    private VertexMap evenWallVerts = new VertexMap();
    private List<int> surfaceTriangles = new List<int>();
    private List<int> evenWallTriangles = new List<int>();
    
    // Start is called before the first frame update
    void Start() {
        Init();
    }

    public void Init() {
        wall = transform.Find("WallMesh");
        surface = transform.Find("Surface");
        _surfaceMesh = new Mesh();
        _wallMesh = new Mesh();
    }

    public Vector2Int PointToHexCoordinate(Vector2 point) {
        return PointToHexCoordinate(new Vector3(point.x, 0, point.y));
    }

    public Vector2Int PointToHexCoordinate(Vector3 point) {
        Vector2Int result = new Vector2Int();
        string algo = "";

        int cX = (int)(point.x / CartGridWidth);
        int cZ = (int)(point.z / CartGridDepth);
        float lX = point.x >= 0 ? (float)point.x % (float)CartGridWidth : (float)CartGridWidth - ((float)point.x % (float)CartGridWidth);
        float lZ = point.z >= 0 ? (float)point.z % (float)CartGridDepth : (float)CartGridDepth - ((float)point.z % (float)CartGridDepth);
        bool stagger = false;

        if (cX % 3 == 0) {
            algo = "Algo L";
            if (cX % 6 != 0) {
                algo = "Algo R";
                stagger = true;
            }
            switch (cZ >= 0 ? cZ % 2 : 2 + (cZ % 2)) {
                case 0:
                    algo += "0";
                    if (stagger) {
                        if (lZ > (CartGridDepth / CartGridWidth) * lX) {
                            algo += "^";
                            result.x = cX / 3 - 1;
                            result.y = cZ / 2;
                        } else {
                            algo += "v";
                            result.x = cX / 3;
                            result.y = cZ / 2 - 1;
                        }
                    } else {

                        if (lZ > (-(CartGridDepth / CartGridWidth) * lX) + (CartGridDepth)) {
                            algo += "^";
                            result.x = cX / 3;
                            result.y = (cZ / 2);
                        } else {
                            algo += "v";
                            result.x = (cX / 3) - (stagger ? 0 : 1);
                            result.y = (cZ / 2) - 1;
                        }
                    }
                    break;
                case 1:
                    algo += "1";
                    if (stagger) {
                        if (lZ > (-(CartGridDepth / CartGridWidth) * lX) + (CartGridDepth)) {
                            algo += "^";
                            result.x = cX / 3;
                            result.y = cZ / 2;
                        } else {
                            algo += "v";
                            result.x = cX / 3 - 1;
                            result.y = cZ / 2;
                        }
                    } else {
                        if (lZ > (CartGridDepth / CartGridWidth) * lX) {
                            algo += "^";
                            result.x = cX / 3 - 1;
                            result.y = cZ / 2;
                        } else {
                            algo += "v";
                            result.x = cX / 3;
                            result.y = cZ / 2;
                        }
                    }
                    break;
            }
        } else {
            algo = "Algo C";
            if ((int)(cX / 3) % 2 != 0) {
                algo = "Algo C Alt";
                cZ -= 1;
            }
            result.x = cX / 3;
            result.y = cZ / 2;
        }

        if (hexes != null) {
            Vector3 origin = new Vector3();
            origin.x = result.x * CartGridWidth * 3 + (CartGridWidth * 2f);
            if (result.x % 2 == 0) {
                origin.z = result.y * CartGridDepth * 2f + (CartGridDepth);
            } else {
                origin.z = result.y * CartGridDepth * 2f + (CartGridDepth * 2f);
            }
            if (hexes.CellAt((int)result.x, (int)result.y) != null) {
                Vector3[] border = new Vector3[] {
                    transform.TransformPoint(new Vector3(origin.x + 2f * CartGridWidth, hexes.CellAt((int)result.x, (int)result.y).height, origin.z)),
                    transform.TransformPoint(new Vector3(origin.x + 1f * CartGridWidth, hexes.CellAt((int)result.x, (int)result.y).height, origin.z + 1f * CartGridDepth)),
                    transform.TransformPoint(new Vector3(origin.x - 1f * CartGridWidth, hexes.CellAt((int)result.x, (int)result.y).height, origin.z + 1f * CartGridDepth)),
                    transform.TransformPoint(new Vector3(origin.x - 2f * CartGridWidth, hexes.CellAt((int)result.x, (int)result.y).height, origin.z)),
                    transform.TransformPoint(new Vector3(origin.x - 1f * CartGridWidth, hexes.CellAt((int)result.x, (int)result.y).height, origin.z - 1f * CartGridDepth)),
                    transform.TransformPoint(new Vector3(origin.x + 1f * CartGridWidth, hexes.CellAt((int)result.x, (int)result.y).height, origin.z - 1f * CartGridDepth))
                };
                Debug.DrawLine(border[0], border[1], Color.red);
                Debug.DrawLine(border[1], border[2], Color.red);
                Debug.DrawLine(border[2], border[3], Color.red);
                Debug.DrawLine(border[3], border[4], Color.red);
                Debug.DrawLine(border[4], border[5], Color.red);
                Debug.DrawLine(border[5], border[0], Color.red);
            }
        }

        return result;
    }

    public void SetHexMap(HexMap map) {
        hexes = map;
        UpdateMesh();
        UpdateColliderMesh();
    }

    public void UpdateMesh() {
        System.DateTime start = System.DateTime.Now;

        GenerateVertices();
        GenerateSurfaceTriangles();
        GenerateWallData();

        surface.GetComponent<MeshFilter>().mesh = surfaceMesh;
        wall.GetComponent<MeshFilter>().mesh = wallMesh;
        surfaceMesh.Clear();
        wallMesh.Clear();
        
        surfaceMesh.vertices = surfaceVerts.CoordinateMap();
        surfaceMesh.normals = surfaceVerts.NormalMap();
        surfaceMesh.triangles = surfaceTriangles.ToArray();
        surfaceMesh.SetUVs(0, surfaceVerts.UVMap());
        
        wallMesh.vertices = evenWallVerts.CoordinateMap();
        wallMesh.normals = evenWallVerts.NormalMap();
        wallMesh.triangles = evenWallTriangles.ToArray();
        wallMesh.SetUVs(0, evenWallVerts.UVMap());

        //evenWallMesh.vertices = verts;
        //evenWallMesh.triangles = evenWallTriangles.ToArray();

        //oddWallMesh.vertices = verts;
        //oddWallMesh.triangles = oddWallTriangles.ToArray();

        System.DateTime end = System.DateTime.Now;
        System.TimeSpan duration = end - start;
        //Debug.Log(duration.ToString());
    }

    public void UpdateColliderMesh() {
        MeshCollider surfaceCollider = surface.GetComponent<MeshCollider>();
        if(surfaceCollider != null) {
            surfaceCollider.sharedMesh = surfaceMesh;
        }
        MeshCollider wallCollider = wall.GetComponent<MeshCollider>();
        if (wallCollider != null) {
            wallCollider.sharedMesh = wallMesh;
        }
    }
    
    private void GenerateVertices() {
        Vector3[] baseline = new Vector3[7];
        Vector3[] norms = new Vector3[7];
        Vector3 adjust = new Vector3();
        float angle = 0;
        Vector3 peak;
        VertexProperties props;
        ConnectorHex h;
        int index = 0;

        surfaceVerts.Clear();
        
        baseline[0] = new Vector3(CartGridWidth * 2, 0, CartGridDepth);
        norms[0] = Vector3.up;
        peak = baseline[0] + new Vector3(0, 25, 0);
        for (int i = 1; i <= 6; ++i) {
            baseline[i] = new Vector3(baseline[0].x + (Mathf.Cos(angle) * Scalar / 2), baseline[0].y, baseline[0].z + (Mathf.Sin(angle) * Scalar / 2));
            norms[i] = Vector3.up;

            angle += (Mathf.PI * 2f) / 6f;
        }

        HexMap hexMap = new HexMap();
        Vector2 texOffset;
        for (int x = hexes.minX; x <= hexes.maxX; ++x) {
            for (int z = hexes.minZ; z <= hexes.maxZ; ++z) {
                index = surfaceVerts.Count;
                h = new ConnectorHex();
                adjust = new Vector3(
                    SpacingX * x * Scalar,
                    hexes.CellAt(x, z).height,
                    SpacingZ * z + (x % 2 == 0 ? 0 : SpacingZ / 2) * Scalar
                );
                texOffset = new Vector2((float)hexes[x][z].texCoord.x / (float)TileDivisions, (float)(TileDivisions - hexes[x][z].texCoord.y - 1) / (float)TileDivisions);
                for (int c = 1; c < baseline.Length; ++c) {
                    props = new VertexProperties();
                    props.coord = baseline[c] + adjust;
                    props.normal = norms[c];

                    switch(c) {
                        case 1:
                            props.uv = UVClamp(texOffset.x + UVUnit, texOffset.y + (UVUnit * 0.5f)); 
                            break;
                        case 2:
                            props.uv = UVClamp(texOffset.x + (UVUnit * 0.75f), texOffset.y + UVUnit);
                            break;
                        case 3:
                            props.uv = UVClamp(texOffset.x + (UVUnit * 0.25f), texOffset.y + UVUnit);
                            break;
                        case 4:
                            props.uv = UVClamp(texOffset.x, texOffset.y + (UVUnit * 0.5f));
                            break;
                        case 5:
                            props.uv = UVClamp(texOffset.x + (UVUnit * 0.25f), texOffset.y);
                            break;
                        case 6:
                            props.uv = UVClamp(texOffset.x + (UVUnit * 0.75f), texOffset.y);
                            break;
                    }

                    surfaceVerts.Add(surfaceVerts.Count, props);
                }
                
                h.E = index;
                h.NE = index + 1;
                h.NW = index + 2;
                h.W = index + 3;
                h.SW = index + 4;
                h.SE = index + 5;
                h.height = hexes.CellAt(x, z).height;
                h.texCoord = hexes.CellAt(x, z).texCoord;
                h.map = hexes;

                hexMap.SetCellAt(x, z, h);
            }
        }
        hexes = hexMap;
    }

    private void GenerateSurfaceTriangles() {
        surfaceTriangles.Clear();
        for(int x = hexes.minX; x <= hexes.maxX; ++x) {
            for(int z = hexes.minZ; z <= hexes.maxZ; ++z) {
                if(hexes.ContainsKey(x)) {
                    if(hexes[x].ContainsKey(z)) {
                        ConnectorHex h = (ConnectorHex)hexes[x][z];
                        surfaceTriangles.AddRange(new int[] {
                            h.NE, h.E, h.SE,
                            h.SE, h.NW, h.NE,
                            h.NW, h.SE, h.SW,
                            h.NW, h.SW, h.W,
                        });
                    }
                }
            }
        }
    }

    private void GenerateWallData() {
        evenWallVerts.Clear();
        evenWallTriangles.Clear();

        VertexProperties[] props;
        Dictionary<Direction, Vector3> norms = new Dictionary<Direction, Vector3>();
        int index;
        norms.Add(Direction.NE, new Vector3(2f * CartGridWidth, 0, CartGridDepth));
        norms.Add(Direction.N, Vector3.forward);
        norms.Add(Direction.NW, new Vector3(-2f * CartGridWidth, 0, CartGridDepth));
        norms.Add(Direction.SW, new Vector3(-2f * CartGridWidth, 0, -CartGridDepth));
        norms.Add(Direction.S, Vector3.back);
        norms.Add(Direction.SE, new Vector3(-2f * CartGridWidth, 0, -CartGridDepth));

        Vector2 texOffset;
        for(int x = hexes.minX; x <= hexes.maxX; ++x) {
            for(int z = hexes.minZ; z <= hexes.maxZ; ++z) {
                ConnectorHex h = (ConnectorHex)hexes[x][z];
                ConnectorHex a;

                foreach(Direction d in new Direction[] { Direction.NE, Direction.N, Direction.NW }) {
                    index = evenWallVerts.Count;
                    List<VertexProperties> l = new List<VertexProperties>();
                    
                    props = new VertexProperties[4];
                    a = neighbor(x, z, d);
                    if(a != null) {
                        switch (d) {
                            case Direction.NE:
                                props[0].coord = surfaceVerts[h.E].coord;
                                props[1].coord = surfaceVerts[h.NE].coord;
                                props[2].coord = surfaceVerts[a.W].coord;
                                props[3].coord = surfaceVerts[a.SW].coord;
                                if(a.height >= h.height) {
                                    texOffset = new Vector2((float)a.texCoord.x / (float)TileDivisions, (float)(TileDivisions - a.texCoord.y - 1) / (float)TileDivisions);
                                    props[0].normal = norms[Direction.SW];
                                    props[1].normal = norms[Direction.SW];
                                    props[2].normal = norms[Direction.SW];
                                    props[3].normal = norms[Direction.SW];
                                    props[0].uv = UVClamp(texOffset + new Vector2(UVUnit, 0f));
                                    props[1].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.66f, 0f));
                                    props[2].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.66f, UVUnit));
                                    props[3].uv = UVClamp(texOffset + new Vector2(UVUnit, UVUnit));
                                } else {
                                    texOffset = new Vector2((float)h.texCoord.x / (float)TileDivisions, (float)(TileDivisions - h.texCoord.y - 1) / (float)TileDivisions);
                                    props[0].normal = norms[Direction.NE];
                                    props[1].normal = norms[Direction.NE];
                                    props[2].normal = norms[Direction.NE];
                                    props[3].normal = norms[Direction.NE];
                                    props[0].uv = UVClamp(texOffset + new Vector2(0f, UVUnit));
                                    props[1].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.33f, UVUnit));
                                    props[2].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.33f, 0f));
                                    props[3].uv = UVClamp(texOffset + new Vector2(0f, 0f));
                                }
                                break;
                            case Direction.N:
                                props[0].coord = surfaceVerts[h.NE].coord;
                                props[1].coord = surfaceVerts[h.NW].coord;
                                props[2].coord = surfaceVerts[a.SW].coord;
                                props[3].coord = surfaceVerts[a.SE].coord;
                                if (a.height >= h.height) {
                                    texOffset = new Vector2((float)a.texCoord.x / (float)TileDivisions, (float)(TileDivisions - a.texCoord.y - 1) / (float)TileDivisions);
                                    props[0].normal = norms[Direction.S];
                                    props[1].normal = norms[Direction.S];
                                    props[2].normal = norms[Direction.S];
                                    props[3].normal = norms[Direction.S];
                                    props[0].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.66f, 0f));
                                    props[1].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.33f, 0f));
                                    props[2].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.33f, UVUnit));
                                    props[3].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.66f, UVUnit));
                                } else {
                                    texOffset = new Vector2((float)h.texCoord.x / (float)TileDivisions, (float)(TileDivisions - h.texCoord.y - 1) / (float)TileDivisions);
                                    props[0].normal = norms[Direction.N];
                                    props[1].normal = norms[Direction.N];
                                    props[2].normal = norms[Direction.N];
                                    props[3].normal = norms[Direction.N];
                                    props[0].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.33f, UVUnit));
                                    props[1].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.66f, UVUnit));
                                    props[2].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.66f, 0f));
                                    props[3].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.33f, 0f));
                                }
                                break;
                            case Direction.NW:
                                props[0].coord = surfaceVerts[h.NW].coord;
                                props[1].coord = surfaceVerts[h.W].coord;
                                props[2].coord = surfaceVerts[a.SE].coord;
                                props[3].coord = surfaceVerts[a.E].coord;
                                if (a.height >= h.height) {
                                    texOffset = new Vector2((float)a.texCoord.x / (float)TileDivisions, (float)(TileDivisions - a.texCoord.y - 1) / (float)TileDivisions);
                                    props[0].normal = norms[Direction.SE];
                                    props[1].normal = norms[Direction.SE];
                                    props[2].normal = norms[Direction.SE];
                                    props[3].normal = norms[Direction.SE];
                                    props[0].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.33f, 0f));
                                    props[1].uv = UVClamp(texOffset + new Vector2(0f, 0f));
                                    props[2].uv = UVClamp(texOffset + new Vector2(0f, UVUnit));
                                    props[3].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.33f, UVUnit));
                                } else {
                                    texOffset = new Vector2((float)h.texCoord.x / (float)TileDivisions, (float)(TileDivisions - h.texCoord.y - 1) / (float)TileDivisions);
                                    props[0].normal = norms[Direction.NW];
                                    props[1].normal = norms[Direction.NW];
                                    props[2].normal = norms[Direction.NW];
                                    props[3].normal = norms[Direction.NW];
                                    props[0].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.66f, UVUnit));
                                    props[1].uv = UVClamp(texOffset + new Vector2(UVUnit, UVUnit));
                                    props[2].uv = UVClamp(texOffset + new Vector2(UVUnit, 0f));
                                    props[3].uv = UVClamp(texOffset + new Vector2(UVUnit * 0.66f, 0f));
                                }
                                break;
                        }
                        evenWallTriangles.AddRange(new int[] {
                            index, index + 1, index + 2,
                            index, index + 2, index + 3
                        });
                        evenWallVerts.Add(evenWallVerts.Count, props[0]);
                        evenWallVerts.Add(evenWallVerts.Count, props[1]);
                        evenWallVerts.Add(evenWallVerts.Count, props[2]);
                        evenWallVerts.Add(evenWallVerts.Count, props[3]);

                    }
                    
                }

            }
        }
    }

    public void AdjustHeight(int x, int z, int radius, float strength) {
        Hex target = hexes.CellAt(x, z);
        if(target != null) {
            target.height += strength;

            float heightDiff;
            Hex[] neigh = target.Neighbors(radius + 1);
            foreach (Hex h in neigh) {
                float d = (float)h.DistanceTo(target);
                if(d <= radius) {
                    h.height += strength * (-(Mathf.Pow(d / radius, 2)) + 1f);
                }
            }

            // Apply height-based textures
            foreach(Hex h in neigh) {
                heightDiff = 0;
                foreach (Hex h2 in h.Neighbors()) {
                    heightDiff += Mathf.Abs(h2.height - h.height);
                }
                heightDiff /= 6f;
                if (Mathf.Abs(heightDiff) < 0.5f) {
                    h.texCoord = new Vector2Int(0, 0);
                } else if (Mathf.Abs(heightDiff) < 1f) {
                    h.texCoord = new Vector2Int(1, 0);
                } else {
                    h.texCoord = new Vector2Int(2, 0);
                }
            }
            heightDiff = 0;
            foreach (Hex h2 in target.Neighbors()) {
                heightDiff += Mathf.Abs(h2.height - target.height);
            }
            heightDiff /= 6f;

            if (Mathf.Abs(heightDiff) < 0.5f) {
                target.texCoord = new Vector2Int(0, 0);
            } else if (Mathf.Abs(heightDiff) < 1f) {
                target.texCoord = new Vector2Int(1, 0);
            } else {
                target.texCoord = new Vector2Int(2, 0);
            }
        }
    }

    private ConnectorHex neighbor(int x, int z, Direction dir) {
        switch (dir) {
            case Direction.NE:
                if (x % 2 == 0) {
                    if (hexes.ContainsKey(x + 1)) {
                        if (hexes[x + 1].ContainsKey(z)) {
                            return (ConnectorHex)hexes[x + 1][z];
                        }
                    }
                } else {
                    if (hexes.ContainsKey(x + 1)) {
                        if (hexes[x + 1].ContainsKey(z + 1)) {
                            return (ConnectorHex)hexes[x + 1][z + 1];
                        }
                    }
                }
                break;
            case Direction.N:
                if (hexes.ContainsKey(x)) {
                    if (hexes[x].ContainsKey(z + 1)) {
                        return (ConnectorHex)hexes[x][z + 1];
                    }
                }
                break;
            case Direction.NW:
                if (x % 2 == 0) {
                    if (hexes.ContainsKey(x - 1)) {
                        if (hexes[x - 1].ContainsKey(z)) {
                            return (ConnectorHex)hexes[x - 1][z];
                        }
                    }
                } else {
                    if (hexes.ContainsKey(x - 1)) {
                        if (hexes[x - 1].ContainsKey(z + 1)) {
                            return (ConnectorHex)hexes[x - 1][z + 1];
                        }
                    }
                }
                break;
            case Direction.SW:
                if (x % 2 == 0) {
                    if (hexes.ContainsKey(x - 1)) {
                        if (hexes[x - 1].ContainsKey(z - 1)) {
                            return (ConnectorHex)hexes[x - 1][z - 1];
                        }
                    }
                } else {
                    if (hexes.ContainsKey(x - 1)) {
                        if (hexes[x - 1].ContainsKey(z)) {
                            return (ConnectorHex)hexes[x - 1][z];
                        }
                    }
                }
                break;
            case Direction.S:
                if (hexes.ContainsKey(x)) {
                    if (hexes[x].ContainsKey(z - 1)) {
                        return (ConnectorHex)hexes[x][z - 1];
                    }
                }
                break;
            case Direction.SE:
                if (x % 2 == 0) {
                    if (hexes.ContainsKey(x + 1)) {
                        if (hexes[x + 1].ContainsKey(z - 1)) {
                            return (ConnectorHex)hexes[x + 1][z - 1];
                        }
                    }
                } else {
                    if (hexes.ContainsKey(x + 1)) {
                        if (hexes[x + 1].ContainsKey(z)) {
                            return (ConnectorHex)hexes[x + 1][z];
                        }
                    }
                }
                break;
        }
        return null;
    }

    private ConnectorHex neighbor(Vector2Int coord, Direction dir) {
        switch(dir) {
            case Direction.NE:
                if(coord.x % 2 == 0) {
                    if(hexes.ContainsKey(coord.x + 1)) {
                        if(hexes[coord.x + 1].ContainsKey(coord.y)) {
                            return (ConnectorHex)hexes[coord.x + 1][coord.y];
                        }
                    }
                } else {
                    if (hexes.ContainsKey(coord.x + 1)) {
                        if (hexes[coord.x + 1].ContainsKey(coord.y + 1)) {
                            return (ConnectorHex)hexes[coord.x + 1][coord.y + 1];
                        }
                    }
                }
                break;
            case Direction.N:
                if(hexes.ContainsKey(coord.x)) {
                    if(hexes[coord.x].ContainsKey(coord.y + 1)) {
                        return (ConnectorHex)hexes[coord.x][coord.y + 1];
                    }
                }
                break;
            case Direction.NW:
                if (coord.x % 2 == 0) {
                    if (hexes.ContainsKey(coord.x - 1)) {
                        if (hexes[coord.x - 1].ContainsKey(coord.y)) {
                            return (ConnectorHex)hexes[coord.x - 1][coord.y];
                        }
                    }
                } else {
                    if (hexes.ContainsKey(coord.x - 1)) {
                        if (hexes[coord.x - 1].ContainsKey(coord.y + 1)) {
                            return (ConnectorHex)hexes[coord.x - 1][coord.y + 1];
                        }
                    }
                }
                break;
            case Direction.SW:
                if (coord.x % 2 == 0) {
                    if (hexes.ContainsKey(coord.x - 1)) {
                        if (hexes[coord.x - 1].ContainsKey(coord.y - 1)) {
                            return (ConnectorHex)hexes[coord.x - 1][coord.y - 1];
                        }
                    }
                } else {
                    if (hexes.ContainsKey(coord.x - 1)) {
                        if (hexes[coord.x - 1].ContainsKey(coord.y)) {
                            return (ConnectorHex)hexes[coord.x - 1][coord.y];
                        }
                    }
                }
                break;
            case Direction.S:
                if (hexes.ContainsKey(coord.x)) {
                    if (hexes[coord.x].ContainsKey(coord.y - 1)) {
                        return (ConnectorHex)hexes[coord.x][coord.y - 1];
                    }
                }
                break;
            case Direction.SE:
                if (coord.x % 2 == 0) {
                    if (hexes.ContainsKey(coord.x + 1)) {
                        if (hexes[coord.x + 1].ContainsKey(coord.y - 1)) {
                            return (ConnectorHex)hexes[coord.x + 1][coord.y - 1];
                        }
                    }
                } else {
                    if (hexes.ContainsKey(coord.x + 1)) {
                        if (hexes[coord.x + 1].ContainsKey(coord.y)) {
                            return (ConnectorHex)hexes[coord.x + 1][coord.y];
                        }
                    }
                }
                break;
        }
        return null;
    }
    
    public Vector3 HexLocalCoordinate(int x, int z) {
        return HexLocalCoordinate(new Vector2Int(x, z));
    }

    public Vector3 HexWorldCoordinate(Vector2Int coord) {
        Vector3 result = Vector3.zero;
        ConnectorHex h = (ConnectorHex)hexes.CellAt(coord.x, coord.y);
        if (h != null) {
            result = this.transform.localToWorldMatrix.MultiplyPoint((surfaceVerts[((ConnectorHex)h).E].coord + surfaceVerts[((ConnectorHex)h).W].coord) / 2f);
        }

        return result;
    }

    public Vector3 HexWorldCoordinate(Hex h) {
        if(h != null) {
            if(h is ConnectorHex) {
                if(h.map == hexes) {
                    return this.transform.localToWorldMatrix.MultiplyPoint((surfaceVerts[((ConnectorHex)h).E].coord + surfaceVerts[((ConnectorHex)h).W].coord) / 2f);
                }
            }
        }
        return Vector3.zero;
    }

    public Vector3 HexLocalCoordinate(Vector2Int coord) {
        Vector3 result = Vector3.zero;
        ConnectorHex h = (ConnectorHex)hexes.CellAt(coord.x, coord.y);
        if(h != null) {
            result = (surfaceVerts[h.E].coord + surfaceVerts[h.W].coord) / 2f;
        }

        return result;
    }

    public Vector3 HexLocalCoordinate(Hex h) {
        if(h != null) {
            if(h is ConnectorHex) {
                if (h.map == hexes) {
                    return (surfaceVerts[((ConnectorHex)h).E].coord + surfaceVerts[((ConnectorHex)h).W].coord) / 2f;
                }
            }
        }
        return Vector3.zero;
    }

    private Vector2 UVClamp(float x, float y) {
        return new Vector2(Mathf.Clamp01(x), Mathf.Clamp01(y));
    }

    private Vector2 UVClamp(Vector2 input) {
        return new Vector2(Mathf.Clamp01(input.x), Mathf.Clamp01(input.y));
    }

    class ConnectorHex : Hex {
        public int E, NE, NW, W, SW, SE;
    }

    struct VertexProperties {
        public Vector3 coord, normal;
        public Vector2 uv;
    }

    class VertexMap : Dictionary<int, VertexProperties> {
        public VertexMap() : base() {}

        public VertexMap(VertexMap copy) : base(copy) { }

        public Vector3[] CoordinateMap() {
            Vector3[] result = new Vector3[this.Keys.Count];
            foreach (int key in this.Keys) {
                result[key] = this[key].coord;
            }
            return result;
        }

        public Vector3[] NormalMap() {
            Vector3[] result = new Vector3[this.Keys.Count];
            foreach(int key in this.Keys) {
                result[key] = this[key].normal;
            }
            return result;
        }

        public Vector2[] UVMap() {
            Vector2[] result = new Vector2[this.Keys.Count];
            foreach (int key in this.Keys) {
                result[key] = this[key].uv;
            }
            return result;
        }
    }
}
