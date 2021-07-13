using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GamePiece : MonoBehaviour {
    void Start() {
        
    }
    
    void Update() {
        if(isActiveAndEnabled) {
            if(transform.position.y < -50) {
                Rigidbody rb = this.gameObject.GetComponentInChildren<Rigidbody>();
                bool oldKin = rb.isKinematic;
                if(rb != null) {
                    rb.isKinematic = true;
                    rb.velocity = Vector3.zero;
                }
                this.transform.Translate(new Vector3(-transform.position.x, 50f - transform.position.y, -transform.position.z), Space.World);
                if(rb != null) {
                    rb.isKinematic = oldKin;
                }
            }
        }
    }
}
