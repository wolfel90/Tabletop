using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomColorOnStart : MonoBehaviour {
    void Start() {
        MeshRenderer m = gameObject.GetComponent<MeshRenderer>();
        m.material.color = new Color(Random.value, Random.value, Random.value, 1f);
        Destroy(gameObject.GetComponent<RandomColorOnStart>());
    }
}
