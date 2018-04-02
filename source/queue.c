#include "queue.h"

/**
* Push an item into queue, if this is the first item,
* both queue->head and queue->tail will point to it,
* otherwise the oldtail->next and tail will point to it.
*/
void push(struct Queue* queue, void *item) {
	// Create a new node
	Node* n = (Node*)malloc(sizeof(Node));
	n->item = item;
	n->next = NULL;

	if (queue->head == NULL) { // no head
		queue->head = n;
	}
	else{
		queue->tail->next = n;
	}
	queue->tail = n;
	queue->size++;
}
/**
* Return and remove the first item.
*/
int pop(struct Queue* queue) {
	// get the first item
	Node* head = queue->head;
	void *item = head->item;
	// move head pointer to next node, decrease size
	queue->head = head->next;
	queue->size--;
	// free the memory of original head
	free(head);
	return queue->size;
}
/**
* Return but not remove the first item.
*/
void *peek(struct Queue* queue) {
	Node* head = queue->head;
	return head != NULL ? head->item : NULL;
}
