// Red Black Tree Header File

#include <stdbool.h>

typedef enum colors { RED, BLACK } color_t;

typedef struct rb_node
{
    int data;
    rb_node_t *left;
    rb_node_t *right;
    color_t color;
} rb_node_t;

typedef struct red_black_tree
{
    rb_node_t *root;
    size_t size;
} red_black_tree_t;

red_black_tree_t *create_rbt_object(void);
void rbt_insert(red_black_tree_t *rb_tree, int data);
void rbt_delete(red_black_tree_t *rb_tree, int data);
bool rbt_search(red_black_tree_t *rb_tree, int data, int *result);

void rbt_preorder(red_black_tree_t *rb_tree);
void rbt_inorder(red_black_tree_t *rb_tree);
void rbt_postorder(red_black_tree_t *rb_tree);
