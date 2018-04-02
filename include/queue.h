#include <stdlib.h>
/**
 * queue.h
 **
 * @version 0.1
 * @file Declares the queue API.
 * @autor Bai Ben
 * @link http://ben-bai.blogspot.de/2012/04/simple-queue-data-structure-in-ansi-c.html
 * @updated_by Mathias Winterhalter
 **
 * @udpate Replaced item type to void pointer.
 */


/**
 * The Node struct, contains current item and the pointer that point to next node.
 */
typedef struct Node {
	void *item; 
	struct Node* next;
} Node;

/**
 * The Queue struct, contains the pointers that
 * point to first node and last node, the size of the Queue,
 * and the function pointers.
 */
typedef struct Queue {
	Node* head;
	Node* tail;

	void(*push) (struct Queue*, void *); // add item to tail
	// get item from head and remove it from queue
	int(*pop) (struct Queue*);
	// get item from head but keep it in queue
	void*(*peek) (struct Queue*);
	// display all element in queue
	void(*display) (struct Queue*);
	// size of this queue
	int size;
} Queue;

/**
 * Push an item into queue, if this is the first item,
 * both queue->head and queue->tail will point to it,
 * otherwise the oldtail->next and tail will point to it.
 */
void push(struct Queue* queue, void *item);

/**
 * Return and remove the first item.
 */
int pop(struct Queue *queue);

/**
 * Return but not remove the first item.
 */
void *peek(struct Queue* queue);

