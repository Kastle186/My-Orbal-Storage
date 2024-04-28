#include <stdio.h>
#include <stdlib.h>
#include "red_black_tree.h"

red_black_tree_t *create_rbt_object(void)
{
    red_black_tree_t *tree = (red_black_tree_t *) malloc(sizeof(red_black_tree_t));
    tree->root = NULL;
    tree->size = 0;
    return tree;
}

void rbt_insert(red_black_tree_t *rb_tree, int data)
{
    rb_node_t *new_node = (rb_node_t *) malloc(sizeof(rb_node_t));

    new_node->data = data;
    new_node->left = NULL;
    new_node->right = NULL;

    // If this is the first node, then make it the root node and set it to Black.

    if (rb_tree->size == 0)
    {
        new_node->color = BLACK;
        rb_tree->root = new_node;
        rb_tree->size++;

        return ;
    }

    new_node->color = RED;
    rb_node_t *pointer = rb_tree->root;
    rb_node_t *parent = NULL;

    // First, we have to insert the new node to the tree, just like we would to
    // a normal binary search tree.

    while (true)
    {
        if (data < pointer->data)
        {
            if (pointer->left == NULL)
            {
                pointer->left = new_node;
                break;
            }
            else
            {
                parent = pointer;
                pointer = pointer->left;
                continue;
            }
        }
        else if (data >= pointer->data)
        {
            if (pointer->right == NULL)
            {
                pointer->right = new_node;
                break;
            }
            else
            {
                parent = pointer;
                pointer = pointer->right;
                continue;
            }
        }
    }

    // Next, we have to rearrange/rebalance the tree if necessary:
    //
    // - If the parent of this new node is a Black-Colored node, then the tree
    //   is alright and we can say this insertion was successful.
    //
    // - If the parent of this new node is a Red-Colored node, one of two options
    //   can happen:
    //
    //     ^ Said parent has no sibling, or a Black-Colored sibling: We have to
    //       rebalance with a "suitable rotation".
    //
    //     ^ Said parent has a Red-Colored sibling: We have to recolor the parent,
    //       their sibling, and the grandparent to Black-Colored nodes.

    if (parent->color == RED)
    {
    }

    rb_tree->size++;
    return ;
}

void rbt_delete(red_black_tree_t *rb_tree, int data)
{
    return ;
}

void rbt_search(red_black_tree_t *rb_tree, int data, int *result)
{
    return ;
}

void rbt_preorder(red_black_tree_t *rb_tree)
{
    return ;
}

void rbt_inorder(red_black_tree_t *rb_tree)
{
    return ;
}

void rbt_postorder(red_black_tree_t *rb_tree)
{
    return ;
}
