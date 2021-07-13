using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HexTile : MonoBehaviour {
    public HexGrid ParentGrid { get; set; } = null;
    public Vector3Int GridPosition { get; set; } = new Vector3Int();
}
