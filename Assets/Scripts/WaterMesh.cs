using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
public class WaterMesh : MonoBehaviour {
    public float Width = 1;
    public float Depth = 1;
    public int XVerts = 5;
    public int ZVerts = 5;
    public float WaveHeight = 1;
    private Mesh mesh = null;
    private float angle = 0;
    private int[][] vertIndices;

    // Start is called before the first frame update
    void Start() {
        mesh = new Mesh();
        GetComponent<MeshFilter>().mesh = mesh;
        GenerateMesh();
    }

    // Update is called once per frame
    void Update() {
        if(WaveHeight != 0) {
            angle += Time.deltaTime;
            if (angle >= Mathf.PI * 2f) angle = angle % (Mathf.PI * 2f);
            if (angle <= -Mathf.PI * 2f) angle = -(-angle % (Mathf.PI * 2f));

            Vector3[] newVerts = mesh.vertices;
            Vector2[] newUVs = mesh.uv;
            float r = Random.value;
            float newX, newY;
            for (int x = 0; x < vertIndices.Length; ++x) {
                for (int z = 0; z < vertIndices[x].Length; ++z) {
                    newVerts[vertIndices[x][z]].y = ((Mathf.Cos(angle + (Mathf.PI * (float)x / 4f)) + Mathf.Sin(angle + (Mathf.PI * (float)z / 4f))) / 2) * WaveHeight;
                    newX = newUVs[vertIndices[x][z]].x + (0.2f * Time.deltaTime * r * WaveHeight);
                    newY = newUVs[vertIndices[x][z]].y + (0.2f * Time.deltaTime * r * WaveHeight);
                    if (newX < -XVerts) newX = XVerts + newX;
                    if (newX > XVerts) newX = -XVerts + newX;
                    if (newY < -ZVerts) newY = ZVerts + newY;
                    if (newY > ZVerts) newY = -ZVerts + newY;
                    newUVs[vertIndices[x][z]].x = newX;
                    newUVs[vertIndices[x][z]].y = newY;
                }
            }

            mesh.vertices = newVerts;
            mesh.SetUVs(0, newUVs);
        } else {
            this.enabled = false;
        }
    }

    public void SetWaveHeight(float val) {
        WaveHeight = val;
        if(val == 0) {
            this.enabled = false;
        } else {
            this.enabled = true;
        }
    }

    public void GenerateMesh() {
        if(XVerts >= 1 && ZVerts >= 1) {
            Vector3[] verts = new Vector3[XVerts * ZVerts];
            vertIndices = new int[XVerts][];
            Vector3[] norms = new Vector3[XVerts * ZVerts];
            Vector3[] uvs = new Vector3[XVerts * ZVerts];
            int[] triangles = new int[XVerts * ZVerts * 6];
            int index = 0;
            Vector2 uvOffset = new Vector2(Random.value, Random.value);
            for(int x = 0; x < XVerts; ++x) {
                vertIndices[x] = new int[ZVerts];
                for(int z = 0; z < ZVerts; ++z) {
                    verts[index] = new Vector3(
                        (Width / (float)XVerts) * x,
                        0,
                        (Depth / (float)ZVerts) * z
                    );
                    norms[index] = Vector3.up;
                    //uvs[index] = new Vector2((float)x / (float)XVerts, (float)z / (float)ZVerts);
                    //uvs[index] = new Vector2(Mathf.Abs((x % 8f) - 4f) / 4f, Mathf.Abs((z % 8f) - 4f) / 4f);
                    uvs[index] = new Vector2((float)x / 4f, (float)z / 4f) + uvOffset;
                    vertIndices[x][z] = index;
                    ++index;
                }
            }
            index = 0;
            for(int t = 0; t < verts.Length - ZVerts; ++t) {
                if ((t + 1) % ZVerts == 0) continue;

                triangles[index++] = t + ZVerts;
                triangles[index++] = t;
                triangles[index++] = t + 1;

                triangles[index++] = t + ZVerts + 1;
                triangles[index++] = t + ZVerts;
                triangles[index++] = t + 1;
            }
            mesh.vertices = verts;
            mesh.normals = norms;
            mesh.SetUVs(0, uvs);
            mesh.triangles = triangles;
            
        }
    }
}
