using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HexMeshPrototype : MonoBehaviour {
    public GameObject meshBase;
    public int width;
    public int depth;
    public float minHeight;
    public float maxHeight;
    public int texDivisions = 1;

    // Start is called before the first frame update
    void Start() {
        if(meshBase != null) {
            if(meshBase.GetComponent<HexMesh>() != null) {
                GameObject newHexMesh = GameObject.Instantiate(meshBase);
                HexMesh meshScript = newHexMesh.GetComponent<HexMesh>();
                newHexMesh.transform.position = this.transform.position;
                HexMap map = HexMap.GenerateRandomMap(width, depth, minHeight, maxHeight);
                meshScript.TileDivisions = texDivisions;
                meshScript.Init();
                meshScript.SetHexMap(map);
            }
            
        }
        Destroy(this.gameObject);
    }

    // Update is called once per frame
    void Update() {
        
    }
}
