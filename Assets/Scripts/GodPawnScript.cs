using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GodPawnScript : MonoBehaviour {
    private List<string> messages = new List<string>();
    
    void Start() {
        messages.AddRange(new string[] {
            "Greetings, Mortal. I am God Pawn!",
            "God Pawn does not approve...",
            "God Pawn will remember that...",
            "You have disturbed the slumber of God Pawn...",
            "God Pawn awakens...",
            "There is a disturbance in the God Pawn...",
            "Beware the Ides of God Pawn",
            "Live long and God Pawn",
            "Where there's a will, there's a God Pawn",
            "God Pawn saw what you did last summer",
            "Ain't no party like a God Pawn party",
            "Deus Ex Pawnicha",
            "God Pawn smiles upon you this day",
            "God Pawn mode activated",
            "Believe it or not, it's God Pawn",
            "God Pawn likes you",
            "Heavy lies the hand that holds the God Pawn",
            "God Pawn 2024",
            "May the God Pawn be with you",
            "Deliver us unto God Pawn",
            "God Pawn slumbers no more...",
            "Donde esta God Pawn?",
            "With great power, comes God Pawn",
            "Searching in the darkness, you find God Pawn",
            "I want my God Pawn TV",
            "If you ain't God Pawn, you're last",
            "Get up, come on get down with the God Pawn",
            "9/10 God Pawns approve!",
            "Notice me, God Pawn",
            "I got the need, the need for God Pawn",
            "God Pawn was dead the whole time",
            "No, user, God Pawn IS your father",
            "God Pawn is now calculating the ultimate question",
            "Lo, God Pawn harkens!",
            "Wubba lubba God Pawn!",
            "Good God Pawn Morning!",
            "It's your turn to God Pawn",
            "It's dangerous to go alone, take God Pawn",
            "Put the God in the Pawn and drink them both up",
            "A wild God Pawn has appeared!",
            "God Pawn has chosen you...",
            "Remember God Pawn? This is them now",
            "The God Pawn, the Bad, and the Ugly",
            "Bruce, I am God Pawn",
            "Heeeeeeeere's God Pawn!",
            "Come play with God Pawn. Forever and ever and ever",
            "That's the power of God Pawn",
            "Quatro Queso Dos God Pawn",
            "Put the God Pawn down!"
        });
    }

    public string GetRandomMessage() {
        return messages[(Random.Range(0, messages.Count))];
    }
}
